//
//  ViewController.swift
//  MusicAppRefectoring
//
//  Created by Kang on 2023/10/06.
//

import UIKit

class ViewController: UIViewController {

    // 생성 - 테이블 뷰
    let tableView = UITableView()
    
    // 생성 - 서치 컨트롤러
    let searchController = UISearchController()
    
    // 생성 - 네트워크 매니저(싱글톤)
    var networkManager = NetworkManager.shared
    
    // 음악 데이터 관리 매니저
    let musicManager = MusicManager.shared
    
    // 생성 - 음악 데이터(빈배열로 시작)
    var musicArrays: [Music] = []
    
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
        
        setupDatas()
        setupTableView()
        setupTableViewAutoLayout()
        setupNavigationBar()
        setupTabBar()
        setupSearchBar()
    }
    
    // 셋업 - 테이블 뷰
    func setupTableView() {
        
        // 뷰에 테이블 뷰 추가
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(MusicTableViewCell.self, forCellReuseIdentifier: "MusicTableViewCell")
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

    // 셋업 - 네비게이션 바
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // 불투명
        appearance.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

    }
    
    // 셋업 - 탭 바
    func setupTabBar() {
        // UITabBar의 tintColor 설정
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.tintColor = .black
        }
    }
    
    // 서치바 셋팅
    func setupSearchBar() {
        self.title = "Music Search"
        
        // 네비게이션 바에 서치 컨트롤러 추가
        navigationItem.searchController = searchController
        
        searchController.searchBar.delegate = self
        
        // 첫글자 대문자 설정 없애기
        searchController.searchBar.autocapitalizationType = .none
    }
    
    // 셋업 - 데이터 셋업
    func setupDatas() {
        
        // 서버에서 데이터 가져오기
        musicManager.setupDatasFromAPI {
            DispatchQueue.main.async {
                print("데이터 불러옴")
                self.tableView.reloadData()
            }
        }
    }
}

// 확장 - 테이블 뷰 델리게이트
extension ViewController: UITableViewDelegate {
    // 테이블뷰 셀의 높이를 유동적으로 조절하기
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// 확장 - 테이블 뷰 데이터 소스
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musicManager.getMusicArraysFromAPI().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 셀 구성
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicTableViewCell", for: indexPath) as! MusicTableViewCell
        
        // 데이터 전달
        let music = musicManager.getMusicArraysFromAPI()[indexPath.row]
        cell.music = music
        
        cell.likeButtonPressed = { [weak self] (senderCell, isSaved) in
            guard let self = self else { return }
            // 저장이 안되어 있으면
            if !isSaved {
                // 저장 알럿창 띄우기
                self.makeMessageAlert { text, savedAction in
                    // Ok - 선택시
                    if savedAction {
                        self.musicManager.saveMusicData(with: music, message: text) {
                            // 저장여부 설정 및 버튼 스타일 바꾸기
                            senderCell.music?.isSaved = true
                            // 버튼 재설정
                            senderCell.setButtonStatus()
                            print("저장 성공")
                        }
                    } else {
                        print("저장 취소")
                    }
                }
            // 저장되어 있으면
            } else {
                // 저장 취소 알럿창 띄우기
                self.makeRemoveCheckAlert { removeAction in
                    if removeAction {
                        self.musicManager.deleteMusic(with: music) {
                            senderCell.music?.isSaved = false
                            senderCell.setButtonStatus()
                            print("저장된 데이터 삭제")
                        }
                    } else {
                        print("저장된 데이터 삭제 취소")
                    }
                }
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func makeMessageAlert(completion: @escaping (String?, Bool) -> Void) {
        let alert = UIAlertController(title: "음악 관련 메세지", message: "음악과 함께 저장하려는 문장을 입력하세요", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "저장하려는 메세지"
        }
        
        // 저장할 텍스트
        var savedText: String? = ""
        
        // alert창 - 1
        let ok = UIAlertAction(title: "확인", style: .default) { okAction in
            savedText = alert.textFields?[0].text
            completion(savedText, true)
        }
        
        // alert창 - 2
        let cancel = UIAlertAction(title: "취소", style: .default) { cancelAction in
            completion(nil, false)
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        // 창 화면에 띄우기
        self.present(alert, animated: true, completion: nil)
    }
    
    func makeRemoveCheckAlert(completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "저장 음악 삭제", message: "정말 저장된 음악을 지우시겠습니까?", preferredStyle: .alert)
        
        // alert창 - 1
        let ok = UIAlertAction(title: "확인", style: .default) { okAction in
            completion(true)
        }
        
        // alert창 - 2
        let cancel = UIAlertAction(title: "취소", style: .default) { cancelAction in
            completion(false)
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        // 창 화면에 띄우기
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        
        musicManager.fetchDatasFromAPI(with: text) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // 서치바에서 글자가 바뀔때마다 -> 소문자 변환
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.text = searchText.lowercased()
    }
    
    // 유저가 스크롤하는 것이 끝나려는 시점에 호출되는 메서드
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // 스크롤을 내릴 때 -> 탭 바 내리기, 스크롤을 올릴 때 -> 탭 바 올리기
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
