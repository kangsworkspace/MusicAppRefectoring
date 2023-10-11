//
//  DetailTableViewCell.swift
//  MusicAppRefectoring
//
//  Created by Kang on 2023/10/09.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    // 데이터 받을 변수
    var musicSaved: MusicSaved? {
        didSet {
            configureUIWithData()
        }
    }
    
    // like 버튼 클로저 전달
    var likeButtonPressed: ((DetailTableViewCell) -> ()) = { (sender) in }
    
    // update 버튼 클로저 전달
    var updateButtonPressed: ((DetailTableViewCell, String?) -> ()) = { (sender, text) in }
    

    // 생성 - 메인 이미지 뷰
    lazy var mainImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // 생성 - 곡 제목 레이블
    var songNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.setContentCompressionResistancePriority(UILayoutPriority(750), for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // 생성 - 아티스트 이름 레이블
    var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        label.setContentCompressionResistancePriority(UILayoutPriority(750), for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 생성 - 앨범 이름 레이블
    var albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.setContentCompressionResistancePriority(UILayoutPriority(750), for: .vertical)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 생성 - 출시 일자 레이블
    var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 9)
        label.textColor = UIColor.darkGray
        label.setContentCompressionResistancePriority(UILayoutPriority(750), for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 생성 - 백뷰
    var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 생성 - 저장(like) 버튼
    var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.redHeart, for: .normal)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 생성 - 저장한 날짜 레이블
    var savedDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 9)
        label.textColor = UIColor.darkGray
        label.setContentCompressionResistancePriority(UILayoutPriority(750), for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 생성 - 저장한 코멘트 레이블
    var commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        // 넓어지려는 우선순위 올림
        label.setContentCompressionResistancePriority(UILayoutPriority(751), for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 하단 백 뷰
    var bottomBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 업데이트 버튼
    var updateButton: UIButton = {
        let button = UIButton()
        button.setTitle("UPDATE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .darkGray
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 생성 - 스택 뷰
    lazy var mainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [songNameLabel, artistNameLabel, albumNameLabel, releaseDateLabel, backView, savedDateLabel, commentLabel, bottomBackView])
        sv.axis = .vertical
        sv.spacing = 4
        sv.alignment = .fill
        sv.distribution = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setupMain()
    }
    
    // 셀이 재사용되기 전에 호출되는 메서드
    override func prepareForReuse() {
        super.prepareForReuse()
        // 이미지가 바뀌는 것처럼 보이는 현상을 없애기 위해서 실행
        self.mainImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMain() {
        // 콘텐츠 뷰 뒤로 보내기
        sendSubviewToBack(contentView)
        
        setupAddView()
        setupAutoLayout()
    }
    
    
    // 셋업 - 애드 뷰
    func setupAddView() {
        backView.addSubview(likeButton)
        bottomBackView.addSubview(updateButton)
        
        self.addSubview(mainImageView)
        self.addSubview(mainStackView)
    }
    
    // 셋업 - 오토 레이아웃
    func setupAutoLayout() {
        
        // 셋 - 메인 이미지 뷰 오토 레이아웃
        NSLayoutConstraint.activate([
            mainImageView.widthAnchor.constraint(equalToConstant: 100),
            mainImageView.heightAnchor.constraint(equalToConstant: 100),
            
            mainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            mainImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            mainImageView.trailingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: -20)
        ])
        
        // 셋 - 백 뷰 오토 레이아웃
        NSLayoutConstraint.activate([
            backView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // 셋 - 좋아요 버튼 오토 레이아웃
        NSLayoutConstraint.activate([
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            
            likeButton.topAnchor.constraint(equalTo: backView.topAnchor, constant: 0),
            likeButton.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: 0),
            likeButton.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: 0)
        ])
        
        // 셋 - 하단 백 뷰 오토 레이아웃
        NSLayoutConstraint.activate([
            bottomBackView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // 셋 - 업데이트 버튼 오토 레이아웃
        NSLayoutConstraint.activate([
            updateButton.widthAnchor.constraint(equalToConstant: 60),

            updateButton.topAnchor.constraint(equalTo: bottomBackView.topAnchor, constant: 0),
            updateButton.leadingAnchor.constraint(equalTo: bottomBackView.leadingAnchor, constant: 0),
            updateButton.bottomAnchor.constraint(equalTo: bottomBackView.bottomAnchor, constant: 0)
        ])
        
        // 셋 - 스택 뷰 오토 레이아웃
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: 20),
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    // 데이터로 UI 처리
    func configureUIWithData() {
        guard let musicSaved = musicSaved else { return }
        loadImage(with: musicSaved.imageUrl)
        songNameLabel.text = musicSaved.songName
        artistNameLabel.text = musicSaved.artistName
        albumNameLabel.text = musicSaved.albumName
        releaseDateLabel.text = musicSaved.releaseDate
        savedDateLabel.text = "Saved Date: \(musicSaved.savedDateString ?? "")"
        commentLabel.text = musicSaved.myMessage
        setButtonStatus()
    }
    
    // URL ==> 이미지 로드
    func loadImage(with imageUrl: String?) {
        guard let urlString = imageUrl, let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: data)
            }
        }
    }
    
    func setButtonStatus() {
        likeButton.setImage(Image.redHeartFilled, for: .normal)
    }
    
    @objc func likeButtonTapped() {
        likeButtonPressed(self)
    }
 
    @objc func updateButtonTapped() {
        updateButtonPressed(self, musicSaved?.myMessage)
    }
}
