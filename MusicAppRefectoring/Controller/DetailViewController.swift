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
        
        // 저장 취소 얼럿창 띄우기
        cell.likeButtonPressed = { [weak self] (senderCell) in
            guard let self = self else { return }
            
            self.makeRemoveCheckAlert { okAction in
                // 삭제 확인 버튼
                if okAction {
                    // 코어데이터에 삭제 하도록 전달
                    self.musicManager.deleteMusicFromCoreData(with: musicSaved) {
                        self.tableView.reloadData()
                        print("likeButtonPressed - 동작완료")
                    }
                } else {
                    print("삭제 취소")
                }
            }
        }
        
        
        
        // 코멘트 수정 창 띄우기
        cell.updateButtonPressed = { [weak self] (senderCell, message) in
            guard let self = self else { return }
            
            self.makeMessageAlert(with: message) { updateMessage, okAction in
                // 수정 확인 버튼
                if okAction {
                    
                    // 새로운 메세지로 변경
                    senderCell.musicSaved?.myMessage = updateMessage
                    
                    // 코어데이터에 수정 하도록 전달
                    guard let musicSaved = senderCell.musicSaved else { return }
                    self.musicManager.updateMusicToCoreData(with: musicSaved) {
                        senderCell.configureUIWithData()
                        print("코멘트 업데이트 완료")
                    }
                } else {
                    print("수정 취소")
                }
            }
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    // 저장 취소 얼럿창
    func makeRemoveCheckAlert(completion: @escaping (Bool) -> Void) {
        
        let alert = UIAlertController(title: "저장 음악 삭제", message: "정말 저장된 음악을 지우시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { okAction in
            completion(true)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { cancelAction in
            completion(false)
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    // 코멘트 수정 창
    func makeMessageAlert(with message: String?, completion: @escaping (String?, Bool) -> Void) {
        
        let alert = UIAlertController(title: "음악 관련 메세지", message: "음악과 함께 저장하려는 메세지를 입력하세요.", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = message
        }
        
        var savedText: String? = ""
        
        let ok = UIAlertAction(title: "확인", style: .default) { okAction in
            savedText = alert.textFields?[0].text
            completion(savedText, true)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .default) { cancelAction in
            completion(nil, false)
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
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
