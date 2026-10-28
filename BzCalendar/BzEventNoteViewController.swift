//
//  BzEventNoteViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/06.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

protocol BzEventNotesChangeProtocol {
    func eventNotesChange(_ newNotes:String)
}

class BzEventNoteViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    
    @IBAction func doneClicked(_ sender: Any) {
        
        if let delegate = self.notesChangeDelegate {
            delegate.eventNotesChange(self.noteTextView.text)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var noteTextView: UITextView!
    
    var eventNotes : String? = nil
    var notesChangeDelegate : BzEventNotesChangeProtocol? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noteTextView.text = self.eventNotes
    }
    override func viewWillAppear(_ animated: Bool) {
        self.noteTextView.becomeFirstResponder()
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UIScrollViewDelegate
//
//    optional public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
//    optional public func textViewShouldEndEditing(_ textView: UITextView) -> Bool
//    optional public func textViewDidBeginEditing(_ textView: UITextView)
//    optional public func textViewDidEndEditing(_ textView: UITextView)
//    optional public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
//    optional public func textViewDidChange(_ textView: UITextView)
//    optional public func textViewDidChangeSelection(_ textView: UITextView)
//    optional public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
//    optional public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
//    @available(iOS, introduced: 7.0, deprecated: 10.0, message: "Use textView:shouldInteractWithURL:inRange:forInteractionType: instead")
//    optional public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool
//    @available(iOS, introduced: 7.0, deprecated: 10.0, message: "Use textView:shouldInteractWithTextAttachment:inRange:forInteractionType: instead")
//    optional public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool


}
