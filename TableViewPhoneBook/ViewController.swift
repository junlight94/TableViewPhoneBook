//
//  ViewController.swift
//  TableViewPhoneBook
//
//  Created by 이준영 on 2022/03/28.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var textField: UITextField!
    
    // 북마크 구조체
    struct BookMark{
        var data = String()
        var flag = Bool()
    }
    
    // 시작 baseData 하드코딩
    var baseData = ["01071005781","01081524685",
                    "0111532485","0117891534",
                    "0160230011","0161547593",
                    "0190020315","0194567774",
                    "15447155","15882482"]
    
    var copyData = [String]()
    var zeroData = [String]()
    var oneData = [String]()
    var sixData = [String]()
    var nineData = [String]()
    var bookMarkRealData = [String]()
    
    var bookMarkData = [BookMark]()
    
    var bookMarkString = ""
    
    var viewData = [[String]]()
    
    let sectionList = ["즐겨찾기", "010", "011", "016", "019","기타"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        for i in 0 ..< baseData.count {
            bookMarkData.append(BookMark(data: baseData[i], flag: false))
        }
        
        dataSort()
        
        // 단순 키보드 내리기 제스쳐
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    func dataSort() {
        //copyData
        copyData = baseData
        
        viewData = []
        bookMarkRealData = []
        zeroData = []
        oneData = []
        sixData = []
        nineData = []
        
        for i in 0 ..< bookMarkData.count{
            
            if bookMarkData[i].data == bookMarkString{
                bookMarkData[i].flag.toggle()
            }
            
            if bookMarkData[i].flag == true {
                bookMarkRealData.append(bookMarkData[i].data)
                copyData.removeAll(where: { $0 == bookMarkData[i].data })
            }
        }
        
        bookMarkString = ""
        
        //010
        let filter0 = copyData.filter { value in
            return value.starts(with: sectionList[1])
        }
        for i in 0 ..< filter0.count{
            zeroData.append(filter0[i])
            zeroData = Array(Set(zeroData)).sorted()
            copyData.removeAll(where: { $0 == filter0[i] })
        }
        //011
        let filter1 = copyData.filter { value in
            return value.starts(with: sectionList[2])
        }
        for i in 0 ..< filter1.count{
            oneData.append(filter1[i])
            oneData = Array(Set(oneData)).sorted()
            copyData.removeAll(where: { $0 == filter1[i] })
        }
        //016
        let filter6 = copyData.filter { value in
            return value.starts(with: sectionList[3])
        }
        for i in 0 ..< filter6.count{
            sixData.append(filter6[i])
            sixData = Array(Set(sixData)).sorted()
            copyData.removeAll(where: { $0 == filter6[i] })
        }
        //019
        let filter9 = copyData.filter { value in
            return value.starts(with: sectionList[4])
        }
        
        for i in 0 ..< filter9.count{
            nineData.append(filter9[i])
            nineData = Array(Set(nineData)).sorted()
            copyData.removeAll(where: { $0 == filter9[i] })
        }
        
        copyData = copyData.sorted()
        
        viewData.append(bookMarkRealData)
        viewData.append(zeroData)
        viewData.append(oneData)
        viewData.append(sixData)
        viewData.append(nineData)
        viewData.append(copyData)
    }
    
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func addAction(_ sender: Any) {
        guard let text = textField.text else { return }
        baseData.append(text)
        bookMarkData.append(BookMark(data: text, flag: false))
        dataSort()
        textField.text = ""
        tableView.reloadData()
        textField.resignFirstResponder()
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer){
        let tapLocation = gesture.location(in: tableView)
        if let tapIndexPath = tableView.indexPathForRow(at: tapLocation){
            bookMarkString = viewData[tapIndexPath.section][tapIndexPath.item]
        }
        dataSort()
        tableView.reloadData()
     }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    // section count
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionList.count
    }
    // section의 title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionList[section]
    }
    // section의 row count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewData[section].count
    }
    // row에 data 넣기
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.phoneNumberLabel.text = viewData[indexPath.section][indexPath.row]
        
        if indexPath.section == 0 {
            cell.bookMarkImageView.image = UIImage(named: "true")
        } else {
            cell.bookMarkImageView.image = UIImage(named: "false")
        }
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        cell.bookMarkImageView.isUserInteractionEnabled = true
        cell.bookMarkImageView.addGestureRecognizer(tap)

        return cell
    }
}
