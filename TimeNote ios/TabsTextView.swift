//
//  TabsTextView.swift
//  TimeNote ios
//
//  Created by Louis Couture on 2022-05-14.
//

import Foundation


import SwiftUI
import UIKit


struct PositionAwareTextEditor: UIViewRepresentable{
    typealias UIViewType = UITextView
    
    @Binding var text: String;
    
    @Binding var textPos:Int;
    
    @Binding var controller:timeNote;

    func makeUIView(context: Context) -> UITextView {
        let uiTextView = UITextView()

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: uiTextView.frame.size.width, height: 44))

        uiTextView.font = UIFont.systemFont(ofSize: 19)
        uiTextView.text = text;
        uiTextView.delegate = context.coordinator
        
        let tabButton = UIBarButtonItem(image: .init(systemName: "arrow.right.to.line.compact"), primaryAction: UIAction{action in
            context.coordinator.addTab(textView: uiTextView
                                      ) })
        let keyboardDownButton = UIBarButtonItem(image: .init(systemName: "keyboard.chevron.compact.down"), primaryAction: UIAction{action in
            context.coordinator.hideKeyBoard(textView:uiTextView)
        })
        
        toolBar.setItems([tabButton,keyboardDownButton], animated: true)
                uiTextView.inputAccessoryView = toolBar

               uiTextView.autocapitalizationType = .sentences
               uiTextView.isSelectable = true
               uiTextView.isUserInteractionEnabled = true
        
        return uiTextView;
    }
    
    func updateUIView(_ uiView:UITextView, context: Context) {
        uiView.text = text;
        
        //if let selectedRange: UITextRange = uiView.selectedTextRange{

        //    self.textPos = uiView.offset(from: uiView.beginningOfDocument, to: selectedRange.start)
        
    //}
        
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($text, textPos: textPos, controller:controller)
    }
    
}

class Coordinator: NSObject, UITextViewDelegate {
    var text: Binding<String>
    var textPos:Int
    var controller:timeNote;
    

 
    init(_ text: Binding<String>, textPos:Int, controller: timeNote) {
        self.text = text
        self.textPos = textPos
        self.controller = controller;
    }
    
    
    func hideKeyBoard( textView:UITextView){
        textView.resignFirstResponder()
    }
    
    func addTab(textView:UITextView){
        controller.inputText(text: self.text.wrappedValue);
        controller.addTab(cursorPosition: textPos)
        self.text.wrappedValue = controller.sendText();
        
        
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if let selectedRange: UITextRange = textView.selectedTextRange{

            self.textPos = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
        }
    }
 
    func textViewDidChange(_ textView: UITextView) {
        self.text.wrappedValue = textView.text
        if let selectedRange: UITextRange = textView.selectedTextRange{

            self.textPos = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
        }

    }
}
