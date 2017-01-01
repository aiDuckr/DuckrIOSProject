//
//  LCRegisterUserInfoView.swift
//  LinkCity
//
//  Created by 张宗硕 on 1/11/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import UIKit

enum ImageState: Int {
    case ImageStateOrigional
    case ImageStateProcessing
    case ImageStateFinish
}

class LCRegisterUserInfoView: UIView, UITextFieldDelegate, LCPickAndUploadImageViewDelegate {
    
    var isMaleButtonPressed = false
    var isFemaleButtonPressed = false
    var avatarUrl: String?
    var imageState = ImageState.ImageStateOrigional
    weak var delegate: LCRegisterUserInfoViewDelegate?
    
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var nickTextField: UITextField!
    
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var avatarImageView: LCPickAndUploadImageView!
    
    class func createInstance() -> LCRegisterUserInfoView? {
        let nib = UINib(nibName: "LCRegisterUserInfoView", bundle: nil)
        
        let views = nib.instantiateWithOwner(nil, options: nil)
        for object in views {
            if object is LCRegisterUserInfoView {
                let view = object as! LCRegisterUserInfoView
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }
        }
        return nil
    }

    override func awakeFromNib() {
        self.initVariable()
        self.initAvatarView()
        self.updateSexShow()
        self.initNickTextField()
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(280.0, 296.0);
    }
    
    // MARK: Init Functions.
    private func initVariable() {
        self.isMaleButtonPressed = false
        self.isFemaleButtonPressed = false
    }
    
    private func initAvatarView() {
        self.avatarView.layer.borderColor = UIColor.whiteColor().CGColor
        self.avatarView.layer.borderWidth = 4.0
        self.avatarImageView.delegate = self
    }
    
    private func initNickTextField() {
        self.nickTextField.delegate = self
    }
    
    // MARK: Common functions.
    
    private func setPopViewStatus(isHide: Bool) {
        var popUpView :UIView = self
        while false == (popUpView is KLCPopup) {
            popUpView = popUpView.superview!
        }
        popUpView.hidden = isHide
    }
    
    private func updateSexShow() {
        if self.isMaleButtonPressed {
            self.maleButton.backgroundColor = LCSSharedFuncUtil.colorFromRGBA(0x8ccbed, alpha: 1.0)
            self.maleButton.layer.borderWidth = 0.0
        } else {
            self.maleButton.backgroundColor = UIColor.whiteColor()
            self.maleButton.layer.borderColor = LCSSharedFuncUtil.colorFromRGBA(0xc9c5c1, alpha: 1.0).CGColor
            self.maleButton.layer.borderWidth = 1.5
        }
        
        if self.isFemaleButtonPressed {
            self.femaleButton.backgroundColor = LCSSharedFuncUtil.colorFromRGBA(0xf4abc2, alpha: 1.0)
            self.femaleButton.layer.borderWidth = 0.0
        } else {
            self.femaleButton.backgroundColor = UIColor.whiteColor()
            self.femaleButton.layer.borderColor = LCSSharedFuncUtil.colorFromRGBA(0xc9c5c1, alpha: 1.0).CGColor
            self.femaleButton.layer.borderWidth = 1.5
        }
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.birthdayTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func datePickerDoneButton(sender:UIButton) {
        self.birthdayTextField.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    private func checkInput() -> Bool {
        if LCStringUtil.isNullString(self.nickTextField.text) {
            YSAlertUtil.tipOneMessage("请填写昵称！")
            return false
        }
        if LCStringUtil.isNullString(self.birthdayTextField.text) {
            YSAlertUtil.tipOneMessage("请填写生日！")
            return false
        }
        if false == self.isMaleButtonPressed && false == self.isFemaleButtonPressed {
            YSAlertUtil.tipOneMessage("请填写性别！")
            return false
        }
        if LCStringUtil.isNullString(self.avatarUrl) {
            if ImageState.ImageStateOrigional == self.imageState {
                YSAlertUtil.tipOneMessage("请上传头像！")
            } else if ImageState.ImageStateProcessing == self.imageState {
                YSAlertUtil.tipOneMessage("正在上传头像，请稍后再试！")
            }
            return false
        }
        return true
    }
    
    private func uploadDataToServer() {
        YSAlertUtil.showHudWithHint("正在上传信息...")
        LCNetRequester.updateUserInfoWithNick(self.nickTextField.text,
            sex: self.isMaleButtonPressed ? 1 : 2,
            avatarURL: self.avatarUrl,
            livingProvince: "",
            livingPlace: "",
            realName: "",
            school: "",
            company: "",
            birthday: self.birthdayTextField.text,
            signature: "",
            profession: "",
            wantGoPlaces: [],
            haveGoPlaces: []) { (user: LCUserModel?, error: NSError?) -> Void in
                YSAlertUtil.hideHud()
                if nil != error {
                    YSAlertUtil.tipOneMessage(error?.domain)
                } else {
                    YSAlertUtil.tipOneMessage("上传成功...")
                    self.delegate?.registerUserInfoView(self, userInfo: user)
                }
        }
        //[self.delegate inputUserinfoView:self didUpdateUserinfo:user];
    }

    // MARK: UIButton Action.
    @IBAction func maleButtonAction(sender: AnyObject) {
        self.isMaleButtonPressed = !self.isMaleButtonPressed
        if self.isMaleButtonPressed {
            self.isFemaleButtonPressed = false
        }
        self.updateSexShow()
    }
    
    @IBAction func femaleButtonAction(sender: AnyObject) {
        self.isFemaleButtonPressed = !self.isFemaleButtonPressed
        if self.isFemaleButtonPressed {
            self.isMaleButtonPressed = false
        }
        self.updateSexShow()
    }

    @IBAction func confirmButtonAction(sender: AnyObject) {
        self.nickTextField.resignFirstResponder()
        self.birthdayTextField.resignFirstResponder()
        if true == self.checkInput() {
            self.uploadDataToServer()
        }
    }
    
    // MARK: UITextField Delegate.
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if "\n" == string {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func dateTextInputPressed(sender: AnyObject) {
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        calendar.timeZone = NSTimeZone(name: "UTC")!
        let components: NSDateComponents = NSDateComponents()
        components.year = 1991
        components.month = 6
        components.day = 13
        let defaultDate: NSDate = calendar.dateFromComponents(components)!
        
        let inputView = UIView(frame: CGRectMake(0, 0, LCSSharedFuncUtil.deviceWidth(), 240))
        inputView.backgroundColor = UIColor.whiteColor()
        let datePickerView: UIDatePicker = UIDatePicker(frame: CGRectMake(0, 40, 0, 0))
        datePickerView.date = defaultDate
        datePickerView.backgroundColor = UIColor.whiteColor()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        inputView.addSubview(datePickerView) // add date picker to UIView
        datePickerView.frame = CGRectMake((LCSSharedFuncUtil.deviceWidth() - datePickerView.frame.size.width) / 2.0, 40, datePickerView.frame.size.width, datePickerView.frame.size.height)
        print(datePickerView.frame)
        
        let doneButton = UIButton(frame: CGRectMake((LCSSharedFuncUtil.deviceWidth() / 2) - (300 / 2), 0, 300, 50))
        doneButton.setTitle("确定", forState: UIControlState.Normal)
        doneButton.setTitle("确定", forState: UIControlState.Highlighted)
        doneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        
        inputView.addSubview(doneButton) // add Button to UIView
        
        doneButton.addTarget(self, action: "datePickerDoneButton:", forControlEvents: UIControlEvents.TouchUpInside) // set button click event
        
        self.birthdayTextField.inputView = inputView
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
        handleDatePicker(datePickerView) // Set the date on start.
    }
    
    // MARK: LCPickAndUploadImageView Delegate.
    func pickImageDidTaped(imageView: LCPickAndUploadImageView!) {
        self.nickTextField.resignFirstResponder()
        self.birthdayTextField.resignFirstResponder()
    }
    
    func pickSheetClicked(imageView: LCPickAndUploadImageView!, atIndex buttonIndex: NSInteger) {
        if SheetCancelButton != Int32(buttonIndex) {
            self.avatarUrl = nil
            self.imageState = ImageState.ImageStateOrigional
            self.endEditing(false)
            self.setPopViewStatus(true)
        }
    }
    
    func pickAndUploadImageView(imageView: LCPickAndUploadImageView!, didPickImage image: UIImage!) {
        self.imageState = ImageState.ImageStateProcessing
    }
    
    func dissmissPickViewController(imageView: LCPickAndUploadImageView!) {
        self.setPopViewStatus(false)
    }

    func pickAndUploadImageView(imageView: LCPickAndUploadImageView!, didUploadImage imageURL: String?, withError error: NSError?) {
        if nil == error {
            self.imageState = ImageState.ImageStateFinish
            self.avatarUrl = imageURL
        }
    }
    
}

@objc protocol LCRegisterUserInfoViewDelegate {
    func registerUserInfoView(userInfoView: LCRegisterUserInfoView!, userInfo: LCUserModel?)
}
