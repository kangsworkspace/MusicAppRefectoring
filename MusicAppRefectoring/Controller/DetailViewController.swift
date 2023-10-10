//
//  DetailViewController.swift
//  MusicAppRefectoring
//
//  Created by Kang on 2023/10/09.
//

import UIKit

class DetailViewController: UIViewController {

    // 생성 - 테이블 뷰
    let tableView = UITableView()
    
    // 생성 - 데이터 관리 매니저
    let musicManager = MusicManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMain()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // 셋업 - 메인
    func setupMain() {
        
        view.backgroundColor = .white
        
        setupTableView()
        setupTableViewAutoLayout()
    }
    
    // 셋업 - 테이블 뷰
    func setupTableView() {
        
        // 뷰에 테이블 뷰 추가
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: "DetailTableViewCell")
    }
    
    // 셋업 - 테이블 뷰 오토 레이아웃
    func setupTableViewAutoLayout() {
            
        // 오토 레이아웃 설정
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musicManager.getMusicDatasFromCoreData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
        
        // 데이터 전달
        let musicSaved = self.musicManager.getMusicDatasFromCoreData()[indexPath.row]
        cell.musicSaved = musicSaved
        cell.selectionStyle = .none
        return cell
    }
}

// 확장 - 테이블 뷰 델리게이트
extension DetailViewController: UITableViewDelegate {
    
    // 셀 높이 조절
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // 유저가 스크롤하는 것이 끝나려는 시점에 호출되는 메서드
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        UIView.animate(withDuration: 0.3) {
            guard velocity.y != 0 else { return }
            if velocity.y < 0 {
                let height = self.tabBarController?.tabBar.frame.height ?? 0.0
                self.tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY - height)
            } else {
                self.tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY)
            }
        }
    }
}
