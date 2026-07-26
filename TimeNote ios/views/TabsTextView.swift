
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
    
    @ObservedObject var controller:AppController;

    func makeUIView(context: Context) -> UITextView {
        let uiTextView = UITextView()

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: uiTextView.frame.size.width, height: 44))
 
        uiTextView.font = UIFont.systemFont(ofSize: 19)
        uiTextView.delegate = context.coordinator
        
        let tabButton = UIBarButtonItem(image: .init(systemName: "arrow.right.to.line.compact"), primaryAction: UIAction{action in
            context.coordinator.addTab(textView: uiTextView) })
        let keyboardDownButton = UIBarButtonItem(image: .init(systemName: "keyboard.chevron.compact.down"), primaryAction: UIAction{action in
            context.coordinator.hideKeyBoard(textView:uiTextView)
        })
        
        let selectAllButton = UIBarButtonItem(image: .init(systemName: "selection.pin.in.out"), primaryAction: UIAction {action
            in
            context.coordinator.selectAll(textView:uiTextView)
        })
                                              
        
        toolBar.setItems([tabButton,keyboardDownButton, selectAllButton], animated: true)
        uiTextView.inputAccessoryView = toolBar
       uiTextView.autocapitalizationType = .sentences
       uiTextView.isSelectable = true
       uiTextView.isUserInteractionEnabled = true
        
        return uiTextView;
    }
    
    func updateUIView(_ uiView:UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($text, textPos: textPos, controller: controller)
    }
    
}

class Coordinator: NSObject, UITextViewDelegate {
    var text: Binding<String>
    var textPos:Int
    @ObservedObject var controller: AppController
    

 
    init(_ text: Binding<String>, textPos:Int, controller: AppController) {
        self.text = text
        self.textPos = textPos
        self.controller = controller;
    }
    
    
    func hideKeyBoard(textView:UITextView){
        textView.resignFirstResponder()
    }
    
    func selectAll(textView: UITextView) {
        textView.becomeFirstResponder()
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.endOfDocument)
    }
    
    func addTab(textView:UITextView){
        controller.inputText(text: self.text.wrappedValue);
        controller.addTab(cursorPosition: textPos)
        self.text.wrappedValue = controller.text;
        
        
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if let selectedRange: UITextRange = textView.selectedTextRange{

            self.textPos = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
        }
    }
 
    func textViewDidChange(_ textView: UITextView) {
        self.text.wrappedValue = textView.text
        UserDefaults.standard.set(textView.text, forKey: "timenoteText")
        if let selectedRange: UITextRange = textView.selectedTextRange{
            self.textPos = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
        }

    }
}
