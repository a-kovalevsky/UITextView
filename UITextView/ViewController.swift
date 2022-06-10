//
//  ViewController.swift
//  UITextView
//
//  Created by andrew on 27.04.22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.isHidden = true
        //textView.alpha = 0 //прозрачность 0-1
        //textView.text = ""
        
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        textView.backgroundColor = self.view.backgroundColor
        textView.layer.cornerRadius = 15
        
        stepper.value = 17
        stepper.minimumValue = 5
        stepper.maximumValue = 35
        stepper.tintColor = .black
        stepper.backgroundColor = .systemOrange
        stepper.layer.cornerRadius = 5
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .brown
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        progressView.setProgress(0, animated: true)

        //отслеживаем появление клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        //отслеживаем скрытие клавиатуры 
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
//        UIView.animate(withDuration: 0, delay: 5, options: .curveEaseIn, animations: {self.textView.alpha = 1}, completion: {(finished) in
//            self.activityIndicator.stopAnimating()
//            self.textView.isHidden = false
//            self.view.isUserInteractionEnabled = true
//            }) //анимация классическая для того,чтоб активити индикатор исчез и появился текст вью
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            if self.progressView.progress != 1 {
                self.progressView.progress += 0.1
            } else {
                self.activityIndicator.stopAnimating()
                self.textView.isHidden = false
                self.view.isUserInteractionEnabled = true
                self.progressView.isHidden = true
            }
        })
        
    }
//скрытие клавиатуры по тапу
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)//метод для скрытия по тапу в любое место и он будет запускаться
       // textView.resignFirstResponder()//если допустим на экране нескольк полей с клавитурами,скрывает конкретно вызванную клавиатуру для объетка
        
    }
    @objc func updateTextView(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String:AnyObject], let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {return}
        
        if notification.name == UIResponder.keyboardDidHideNotification {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height - bottomConstraint.constant, right: 0)
            textView.scrollIndicatorInsets = textView.contentInset//индикатор скроллинга?
        }
        textView.scrollRangeToVisible(textView.selectedRange)//тапая по текст полю текст будет скролиться куда мы тапаем собстна
    }
    
    @IBAction func sizeFont(_ sender: UIStepper) {
        let font = textView.font?.fontName
        let fontSize = sender.value
        textView.font = UIFont(name: font!, size: fontSize)
    }
}
extension ViewController:UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = .white
        textView.textColor = .gray
    }//срабатывает при тапе на текст вью
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = self.view.backgroundColor
        textView.textColor = .black
        
    }//срабатывает по окончанию работы над текст вью
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        countLabel.text = "\(textView.text.count)"
        return textView.text.count + (text.count - range.length) <= 120 //суть етого такая что изначально каунт текст вью равно нулю,а текст каунт не может быть больше единицы,так как когда вводишь с клавиатуры все вводитсья по одному символу ,далее отнимается рэндж каунт,это стертые бэеспэйсом символы и получается такая вот математика, что 0+(1-0) и сравнивается с общим количесвтом символов,выдеялемый текст тоже работает
    }
}

