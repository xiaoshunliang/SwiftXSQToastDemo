//
//  ViewController.swift
//  XSQToast
//
//  Created by xiaoshunliang on 2017/5/17.
//  Copyright © 2017年 bodaokeji. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let btn1 = UIButton.init(type: .custom);
        btn1.frame = CGRect(x: 100, y: 100, width: 200, height: 50);
        btn1.setTitle("showToast", for: .normal);
        btn1.backgroundColor = UIColor.green;
        btn1.addTarget(self, action: #selector(btnClicked1), for: .touchUpInside);
        self.view.addSubview(btn1);
        
        
        let btn2 = UIButton.init(type: .custom);
        btn2.frame = CGRect(x: 100, y: 200, width: 200, height: 50);
        btn2.setTitle("showLoading", for: .normal);
        btn2.backgroundColor = UIColor.green;
        btn2.addTarget(self, action: #selector(btnClicked2), for: .touchUpInside);
        self.view.addSubview(btn2);
    }
    func btnClicked1() {
        
        let toast = XSQToast();
        toast.showToast("我是弹出来的内容");
    }
    func btnClicked2(){
        let loading = XSQToast();
        loading.showLoading();
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

