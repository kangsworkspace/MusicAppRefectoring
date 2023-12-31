//
//  MusicTableViewCell.swift
//  MusicAppRefectoring
//
//  Created by Kang on 2023/10/07.
//

import UIKit

class MusicTableViewCell: UITableViewCell {
    
    // 생성 - 이미지 URL을 전달받는 변수
    var music: Music? {
        didSet {
            configureUIWithData()
        }
    }
    
    // 셀이 재사용되기 전에 호출되는 메서드
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // 이미지가 바뀌는 것처럼 보이는 형상을 없애기 위해서 실행
        self.mainImageView.image = nil
    }
    
    // 실행하고 싶은 클로저 저장
    // 뷰컨트롤러에 있는 클로저 저장할 예정 (셀(자신)을 전달하고, 저장여부도 전달)
    var likeButtonPressed: ((MusicTableViewCell, Bool) -> ()) = { (sender, pressed) in }
    
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

        // 넓어지려는 우선순위 올림
        label.setContentCompressionResistancePriority(UILayoutPriority(750), for: .vertical)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // 생성 - 아티스트 이름 레이블
    var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        
        // 넓어지려는 우선순위 올림
        label.setContentCompressionResistancePriority(UILayoutPriority(750), for: .vertical)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 생성 - 앨범 이름 레이블
    var albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        
        // 넓어지려는 우선순위 올림
        label.setContentCompressionResistancePriority(UILayoutPriority(751), for: .vertical)
        
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 생성 - 출시 일자 레이블
    var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 9)
        label.textColor = UIColor.darkGray
        
        // 넓어지려는 우선순위 올림
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
    
    // 생성 - 스택 뷰
    lazy var mainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [songNameLabel, artistNameLabel, albumNameLabel, releaseDateLabel, backView])
        sv.axis = .vertical
        sv.spacing = 0
        sv.alignment = .fill
        sv.distribution = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setupMain()
    }
    
    // 오토 레이아웃 설정
    override func updateConstraints() {
        setupAutoLayout()
        super.updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMain() {
        
        // 콘텐츠 뷰 뒤로 보내기
        sendSubviewToBack(contentView)
        
        setupAddView()
    }
    
    // 셋업 - 애드 뷰
    func setupAddView() {
        backView.addSubview(likeButton)
        
        self.addSubview(mainImageView)
        self.addSubview(mainStackView)
    }
    
    // 셋업 - 오토 레이아웃
    func setupAutoLayout() {
        
        // 셋 - 메인 이미지 뷰 오토 레이아웃
        NSLayoutConstraint.activate([
            mainImageView.widthAnchor.constraint(equalToConstant: 100),
            mainImageView.heightAnchor.constraint(equalToConstant: 100),
            mainImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            mainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            mainImageView.trailingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: -20)
        ])
        
        // 셋 - 백 뷰 오토 레이아웃
        NSLayoutConstraint.activate([
            backView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // 셋 - 좋아요 버튼 오토 레이아웃
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: backView.topAnchor, constant: 0),
            likeButton.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: 0),
            likeButton.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: 0),
            
            likeButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        // 셋 - 스택 뷰 오토 레이아웃
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    @objc func likeButtonTapped(_ sender: UIButton) {
        
        guard let isSaved = music?.isSaved else { return }
        
        print("likeButtonTapped 실행")
        // 자신을 전달 -> 클로저 실행
        likeButtonPressed(self, isSaved)
        setButtonStatus()
    }
    
    
    func configureUIWithData() {
        guard let music = music else { return }
        loadImage(with: music.imageUrl)
        songNameLabel.text = music.songName
        artistNameLabel.text = music.artistName
        albumNameLabel.text = music.albumName
        releaseDateLabel.text = music.releaseDateString
        setButtonStatus()
    }
    
    // URL -> 이미지 로드
    private func loadImage(with imageUrl: String?) {
        guard let urlString = imageUrl, let url = URL(string: urlString)  else { return }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            // 오래걸리는 작업이 일어나고 있는 동안에 url이 바뀔 가능성 제거
            guard urlString == url.absoluteString else { return }
            
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: data)
            }
        }
    }
    
    func setButtonStatus() {
        guard let isSaved = self.music?.isSaved else { return }
        // 저장이 되지 않았으면
        if !isSaved {
            likeButton.setImage(Image.redHeart, for: .normal)
        // 저장이 되어 있으면
        } else {
            likeButton.setImage(Image.redHeartFilled, for: .normal)
        }
    }
}
