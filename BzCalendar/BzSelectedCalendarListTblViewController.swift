//
//  BzSelectedCalendarListTblViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/02.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit


// 拡張機能でのカレンダーの選択と、通常のカレンダーの選択の２つを兼ねたクラス
// 拡張機能の場合は、セルを選択すると（Storyboardの設定によりSegueが呼ばれ）次の画面をプッシュするが、
// カレンダーの選択の場合はカレンダーのセルにチェックマークを入れる
class BzSelectedCalendarListTblViewController: UITableViewController {

    // EKSource別にEKCalendarをグループ化する
    // EKSourceの順序をkeyOrderArrayで示し
    // calendarDictで、keyをEKSourceのsourceIdentifierで、ソートされているEKCalendarのArrayを格納している
    // ここから
    fileprivate var calendarSources : Array<EKSource> = Array()
    fileprivate var calendarDict : Dictionary
        <String, Array<EKCalendar>> = Dictionary()
    // ここまで

    var markSelectedCalendar : Bool = false
    var selectedCalendars : Set<EKCalendar> = Set()
    var calendarDelegate : BzCalendarChooserDelegate? = nil
    
    var onlyWritableCalendars: Bool = true
    var isMultiSelect : Bool = false
    
    @IBAction func doneClicked(_ sender: Any) {
        if let delegate = self.calendarDelegate {
            delegate.selectedCalendars(Array(self.selectedCalendars))
            if let calendar = self.selectedCalendars.first {
                delegate.selectedCalendar(calendar)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // ToDo: - カラーリング対応
        self.navigationController?.navigationBar.tintColor = UIColor.white

        self.title = NSLocalizedString("ViewTitle_CustomSetting_Calendar", comment:"カレンダー")
        
        self.calendarSources = Array()
        self.calendarDict = Dictionary()
        
        self.updateCalendarDict()
    
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.calendarSources.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let source = self.calendarSources[section]
        if let calendars = self.calendarDict[source.sourceIdentifier] {
            return calendars.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let CellIdentifier = "costumCalendarSelectCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as?
            BzColorSettingTableViewCell else {
            fatalError()
        }
        
        
        // Configure the cell...
        let cal : EKCalendar = self.ekCalendarAtIndexPath(indexPath: indexPath)
        
        cell.accessoryType = .none;
        if self.markSelectedCalendar == true {
            if self.selectedCalendars.contains(cal) {
                cell.accessoryType = .checkmark
            }
        } else {
            cell.accessoryType = .disclosureIndicator;
        }
        cell.colorSampleView.backgroundColor = cal.bgColor();
        cell.colorName.text = cal.title;

        let colorUtil = ColorUtil.shared
        let colorCode = colorUtil.colorCode(color: cal.bgColor())
        let noshadow = self.traitCollection.userInterfaceStyle == .dark

        cell.colorCode.attributedText = colorUtil.atributedColorCode(code: colorCode, noShadow: noshadow)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let source = self.calendarSources[section]
        return source.title;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let calendar = self.ekCalendarAtIndexPath(indexPath: indexPath)
        
        if self.isMultiSelect == true {
            if self.selectedCalendars.contains(calendar) {
                self.selectedCalendars.remove(calendar)
            }
        } else {
            self.selectedCalendars.removeAll()
        }
        self.selectedCalendars.insert(calendar)

        self.tableView.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // 選択モードの時はfalseを返すというやり方もある事を示すためにこのコードを残している
        
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "customizeCalendarSegue" {
            if let nextViewController = segue.destination as? BzCustomizeCalendarTblViewController {
                if let selectedIndex = self.tableView.indexPathForSelectedRow {
                    let cal = self.ekCalendarAtIndexPath(indexPath: selectedIndex)
                    nextViewController.calendar = cal
                }
            }
        }
        
    }

    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        return false
    }
//    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
//        
//    }
    
}

// MARK:- 以下はドメインモデルやサービスに移したい
extension BzSelectedCalendarListTblViewController {
    
    // ToDo:
    //      ドメインモデルやサービスに移す
    fileprivate func updateCalendarDict() {
        
        guard let store = AppEventKit.shared.store() else {
            return
        }
        
        let tmpSources = store.sources.filter { (source) -> Bool in
            if self.onlyWritableCalendars == true {
                if source.sourceType == .birthdays {
                    return false
                } else if source.sourceType == .subscribed {
                    return false
                }
            }
            return true
        }
        self.calendarSources = tmpSources.sorted(by: {
            s1, s2 in
            if s1.sourceType.rawValue < s2.sourceType.rawValue {
                return true
            } else if s1.sourceType.rawValue > s2.sourceType.rawValue {
                return false
            }
            switch s1.title.compare(s2.title) {
            case .orderedAscending, .orderedSame:
                return true
            case .orderedDescending:
                return false
            }
        })

        for source in self.calendarSources {
            let calendars = source.calendars(for: .event).filter {
                (source) -> Bool in
                if self.onlyWritableCalendars == true {
                    if source.isSubscribed == true {
                        return false
                    }
                }
                return true
            }
            self.calendarDict[source.sourceIdentifier] = Array(calendars)
        }
        
        
        for source in self.calendarSources {
            if var mutArr = self.calendarDict[source.sourceIdentifier] {
                mutArr.sort {
                    return $0.title < $1.title
                    //return $0.calendarIdentifier < $1.calendarIdentifier
                }
                self.calendarDict[source.sourceIdentifier] = mutArr
            }
        }
    } // func updateCalendarDict()

    fileprivate func ekCalendarAtIndexPath(indexPath:IndexPath) -> EKCalendar {
        let source = self.calendarSources[indexPath.section]
        return self.calendarDict[source.sourceIdentifier]![indexPath.row]
        
    }
}
