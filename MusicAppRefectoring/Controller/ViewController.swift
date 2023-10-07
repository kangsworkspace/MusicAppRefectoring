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
    
    // 생성 - 서치 컨트롤러 **임시 세팅**
    let searchController = UISearchController()
    
    // 생성 - 네트워크 매니저(싱글톤)
    var networkManager = NetworkManager.shared
    
    // 생성 - 음악 데이터(빈배열로 시작)
    var musicArrays: [Music] = []
    
    // 생성 - 검색 단어(서치바에서 전달받음)
    var searchTerm: String? {
        didSet {
            setupDatas()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMain()
    }
    

    // 셋업 - 메인
    func setupMain() {
        
        setupDatas()
        setupTableView()
        setupTableViewAutoLayout()
        setupNavigationBar()
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
        
        guard let term = searchTerm else { return }
        
        // (네트워킹 시작전에) 다시 빈배열로 만들기
        self.musicArrays = []
        
        // 네트워킹 시작
        networkManager.fetchMusic(searchTerm: term) { result in
            print(#function)
            switch result {
            case .success(let musicDatas):
                // 데이터(배열)을 받아오고 난 후
                self.musicArrays = musicDatas
                // 테이블뷰 리로드
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
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
        print(#function)
        return self.musicArrays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 셀 구성
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicTableViewCell", for: indexPath) as! MusicTableViewCell
        
        cell.imageUrl = musicArrays[indexPath.row].imageUrl
        cell.songNameLabel.text = musicArrays[indexPath.row].songName
        cell.artistNameLabel.text = musicArrays[indexPath.row].artistName
        cell.albumNameLabel.text = musicArrays[indexPath.row].albumName
        cell.releaseDateLabel.text = musicArrays[indexPath.row].releaseDateString
        
        cell.selectionStyle = .none
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("서치바에 입력되는 단어", searchController.searchBar.text ?? "")

        // 찾으려는 단어 전달
        searchTerm = searchController.searchBar.text ?? ""
    }
}
