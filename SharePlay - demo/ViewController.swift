//
//  ViewController.swift
//  SharePlay - demo
//
//  Created by Kathan Lunagariya on 27/10/21.
//

import UIKit
import GroupActivities


class ViewController: UIViewController {
    
    var groupSession:GroupSession<EditTogether>?
    var groupStateObserver = GroupStateObserver()
    var messanger:GroupSessionMessenger?
    
    let container:UIView = {
      
        let view = UIView()
        return view
    }()
    
    let card:UIView = {
       
        let view = UIView()
        view.backgroundColor = .systemPink
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
//    let lbl:UILabel = {
//
//        let lbl = UILabel()
//        lbl.text = "Hello, Share-Play..."
//        lbl.numberOfLines = 0
//        lbl.adjustsFontSizeToFitWidth = true
//        lbl.font = .preferredFont(forTextStyle: .largeTitle)
//        lbl.textAlignment = .center
//        lbl.textColor = .black
//        return lbl
//    }()
    
    let textView:UITextView = {
       
        let txt = UITextView()
        txt.text = "Hello, Share-Play..."
        txt.backgroundColor = .clear
        txt.textAlignment = .center
        txt.textColor = .black
        txt.font = .preferredFont(forTextStyle: .largeTitle)
        txt.contentInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        return txt
    }()
    
    let addButton:UIButton = {
        
        let btn = UIButton()
        btn.tag = 1
        btn.configuration = .tinted()
        btn.configuration?.image = UIImage(systemName: "plus.circle.fill")
        btn.configuration?.cornerStyle = .capsule
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    //actions...
    let actionView:UIView = {
      
        let view = UIView()
        //view.backgroundColor = .black
        view.layer.cornerRadius = 10
        return view
    }()
    

    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        if groupSession == nil && groupStateObserver.isEligibleForGroupSession{
            
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "shareplay"), style: .plain, target: self, action: #selector(didTapSharePlay))
        
        textView.delegate = self
        
        card.addSubview(textView)
        container.addSubview(card)
        container.addSubview(addButton)
        view.addSubview(container)
        
        container.frame = CGRect(x: view.safeAreaInsets.left, y: view.safeAreaInsets.top, width: view.frame.width, height: view.frame.height)
        card.frame = CGRect(x: 0, y: 0, width: view.frame.width - 75, height: view.frame.width - 75)
        card.center = view.center
        textView.frame = card.bounds
        
        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 75),
            addButton.heightAnchor.constraint(equalToConstant: 75)
        ])
        addButton.addTarget(self, action: #selector(didTapAdd(sender:)), for: .touchUpInside)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignTextView)))
        
        setUpActionViewInitials()
        
        
        //MARK: FOR JOINING TO GROUP SESSION...
        Task{
            for await session in EditTogether.sessions(){
                self.configureGroupSession(session)
            }
        }
    }
    
    func setUpActionViewInitials(){
        
        let closeBtn:UIButton = {
           
            let btn = UIButton()
            btn.tag = 2
            btn.configuration = .tinted()
            btn.configuration?.image = UIImage(systemName: "multiply")
            btn.configuration?.cornerStyle = .capsule
            btn.tintColor = .red
        
            btn.translatesAutoresizingMaskIntoConstraints = false
            return btn
        }()
        
        let colorBtn:UIButton = {
           
            let btn = UIButton()
            btn.configuration = .gray()
            btn.configuration?.image = UIImage(systemName: "paintpalette.fill")
            btn.configuration?.imagePadding = 15
            btn.configuration?.title = "Change Color"
            btn.configuration?.cornerStyle = .capsule
            return btn
        }()
        
        let fontBtn:UIButton = {
           
            let btn = UIButton()
            btn.configuration = .gray()
            btn.configuration?.image = UIImage(systemName: "a")
            btn.configuration?.imagePadding = 15
            btn.configuration?.title = "Change Font"
            btn.configuration?.cornerStyle = .capsule
            return btn
        }()
        
        let stack = UIStackView()
        stack.addArrangedSubview(colorBtn)
        stack.addArrangedSubview(fontBtn)
        stack.distribution = .fillEqually
        stack.spacing = 15
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        actionView.addSubview(closeBtn)
        actionView.addSubview(stack)
        view.addSubview(actionView)
        
        
        let initialFrame = CGRect(x: view.frame.width + 10, y: view.center.y - 100, width: 250, height: 200)
        actionView.frame = initialFrame
        
        NSLayoutConstraint.activate([
            closeBtn.topAnchor.constraint(equalTo: actionView.topAnchor, constant: 10),
            closeBtn.trailingAnchor.constraint(equalTo: actionView.trailingAnchor, constant: -10),
            closeBtn.widthAnchor.constraint(equalToConstant: 50),
            closeBtn.heightAnchor.constraint(equalToConstant: 50),
            
            stack.topAnchor.constraint(equalTo: closeBtn.bottomAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: actionView.leadingAnchor, constant: 25),
            stack.trailingAnchor.constraint(equalTo: actionView.trailingAnchor, constant: -25),
            stack.bottomAnchor.constraint(equalTo: actionView.bottomAnchor, constant: -10)
        ])
        
        setUpActionViewBGColor()
        
        closeBtn.addTarget(self, action: #selector(didTapAdd(sender:)), for: .touchUpInside)
        colorBtn.addTarget(self, action: #selector(didTapColorPicker), for: .touchUpInside)
        fontBtn.addTarget(self, action: #selector(didTapFontSelection), for: .touchUpInside)
    }
    
    
    @objc func setUpActionViewBGColor(){
        
        if UITraitCollection.current.userInterfaceStyle == .dark{
            self.actionView.backgroundColor = .white
        }else{
            self.actionView.backgroundColor = .black
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setUpActionViewBGColor()
    }
    
    
    @objc func didTapAdd(sender:UIButton){
        
        //appear actionView...
        if sender.tag == 1{
            UIView.animate(withDuration: 2) {
                self.container.transform = CGAffineTransform(translationX: -270, y: 0)
                self.actionView.transform = CGAffineTransform(translationX: -270, y: 0)
            }
        }
        else{
            UIView.animate(withDuration: 2) {
                self.container.transform = .identity
                self.actionView.transform = .identity
            }
        }
    }
    
    @objc func didTapSharePlay() {
        Task {
            do {
                _ = try await EditTogether().activate()
            } catch {
                print("Failed to activate DrawTogether activity: \(error)")
            }
        }
    }
    
    @objc func resignTextView(){
        textView.resignFirstResponder()
    }
}


extension ViewController: UIColorPickerViewControllerDelegate, UIFontPickerViewControllerDelegate, UITextViewDelegate{
    
    @objc func didTapColorPicker(){
        
        let picker = UIColorPickerViewController()
        picker.supportsAlpha = false
        picker.title = "card background"
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
    }
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        DispatchQueue.main.async {
            self.card.backgroundColor = color
            
            if self.container.transform != .identity{
                self.container.transform = .identity
                self.actionView.transform = .identity
            }
        }
        
        
        //share-play sharing part...
        if let messanger = messanger{
            let editedData = SharedEditData(cardBGColor: Color(uiColor: color), fontDescriptor: Descriptor(family: self.textView.font?.familyName ?? "Arial"), Text: self.textView.text)
            
            Task{
                do{
                    try await messanger.send(editedData)
                }
                catch{
                    print("error with group activity in color-picker...")
                }
            }
        }
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
        
        UIView.animate(withDuration: 0.5) {
            self.container.transform = CGAffineTransform(translationX: -270, y: 0)
            self.actionView.transform = CGAffineTransform(translationX: -270, y: 0)
        }
    }
    
    
    @objc func didTapFontSelection(){
        
        let picker = UIFontPickerViewController()
        picker.delegate = self
        
        guard let controller = picker.sheetPresentationController else {
            print("sheet controller is nil..")
            return
        }
        controller.detents = [.medium()]
        
        present(picker, animated: true, completion: nil)
    }
    
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        
        guard let descriptor = viewController.selectedFontDescriptor else {
            print("font descriptor is nil...")
            return
        }
        
        DispatchQueue.main.async {
            self.textView.font = UIFont(descriptor: descriptor, size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
            
            if self.container.transform != .identity{
                self.container.transform = .identity
                self.actionView.transform = .identity
            }
        }
        
        
        //share-play sharing part...
        if let messanger = messanger{
            let editedData = SharedEditData(cardBGColor: Color(uiColor: self.card.backgroundColor ?? .black), fontDescriptor: Descriptor(family: viewController.selectedFontDescriptor!.fontAttributes[.family] as! String), Text: self.textView.text)
            
            Task{
                do{
                    try await messanger.send(editedData)
                }
                catch{
                    print("error with group activity in color-picker...")
                }
            }
        }
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func fontPickerViewControllerDidCancel(_ viewController: UIFontPickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
        
        UIView.animate(withDuration: 0.5) {
            self.container.transform = CGAffineTransform(translationX: -270, y: 0)
            self.actionView.transform = CGAffineTransform(translationX: -270, y: 0)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        guard let txt = textView.text else {
            print("text found nil...")
            return
        }
        self.textView.text = txt
        
        //share-play sharing part...
        if let messanger = messanger{
            let editedData = SharedEditData(cardBGColor: Color(uiColor: self.card.backgroundColor ?? .black), fontDescriptor: Descriptor(family: self.textView.font?.familyName ?? "Arial"), Text: txt)
            
            Task{
                do{
                    try await messanger.send(editedData)
                }
                catch{
                    print("error with group activity in textView...")
                }
            }
        }
    }
}



extension ViewController{
    
    //MARK: JOINING GROUP SESSION...
    func configureGroupSession(_ groupSession: GroupSession<EditTogether>){
        
        self.groupSession = groupSession
        let messanger = GroupSessionMessenger(session: groupSession)
        self.messanger = messanger
        
        let editTask = detach { [weak self] in
            for await (msg, _) in messanger.messages(of: SharedEditData.self){
                await self?.handle(msg)
            }
        }
        
        groupSession.join()
    }
    
    
    func handle(_ message: SharedEditData){
        
        card.backgroundColor = message.cardBGColor.uiColor
        textView.font = UIFont(name: message.fontDescriptor.name, size: textView.font?.pointSize ?? UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
        textView.text = message.Text
    }
}
