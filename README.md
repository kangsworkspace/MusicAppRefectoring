# MusicAppRefectoring

## 🖥️ 프로젝트 소개

- 네트워킹을 통해 검색한 음악을 보여주는 기존의 프로젝트()에 좋아하는 곡을 저장하는 기능을 추가하였습니다.
- CoreData를 통해 곡들을 저장하였습니다.
- 조건(좋아하는 곡으로 추가했는지, 어떤 페이지에 있는지)에 따른 UI 변화를 나타내었습니다.

<br>

## 👀 프로젝트 구성

- 프로젝트에 사용 : UINavigationBar(), UITableView(), UITabBar(), UIAlertController(), UISearchController(), URLSession 및 .dataTask 를 비롯한 네트워킹 기능, CoreData, 
  
- 총 두개의 페이지로 구성되어 있습니다.
첫번째 페이지는 주어진 검색어로 네트워킹을 통해 받은 음악들을 TableView()로 표시하는 페이지 입니다.
두번째 페이지는 첫번째 페이지의 음악 중 likeButton()을 누른 곡들을 CoreData에 저장하고 그 데이터들을 보여주는 페이지 입니다..

<br>

## 📌 학습한 주요 내용

#### 상태에 따른 UI 처리

1. 어떤 페이지에 있는지에 따라 해당 탭 바의 이미지와 텍스트를 다르게 표현하고자 하였습니다.
탭 바의 이미지는 UITabBarController() 내의 .tabBar.items.selectedImage를 통해 다른 이미지를 표시하였습니다.
탭 바의 텍스트는 아래와 같이 해당 뷰 컨트롤러에서 if let 문을 통해 현재 탭바의 tintColor 색깔을 바꾸는 것으로 표시하였습니다.
```
    func setupTabBar() {
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.tintColor = .black
        }
    }
```

2. isSaved 저장 속성의 참/거짓 유무에 따라 likeButton의 이미지를 다르게 나타내었습니다.
아래의 함수를 만들어 isSaved 속성이 변경될 수 있을 때마다 해당 함수를 동작시켰습니다.
```
    func setButtonStatus() {
        guard let isSaved = self.music?.isSaved else { return }
        if !isSaved {
            likeButton.setImage(Image.redHeart, for: .normal)
        } else {
            likeButton.setImage(Image.redHeartFilled, for: .normal)
        }
    }
```

## 🎬 완성된 모습
![1](https://github.com/kangsworkspace/DataStorage/assets/141600830/07873aba-4761-4a36-be6c-ba4e369b862d)
![2](https://github.com/kangsworkspace/DataStorage/assets/141600830/00bd129d-9d04-4328-b6c6-1d8a63a51dfa)
![3](https://github.com/kangsworkspace/DataStorage/assets/141600830/476e186d-850d-49fa-8877-959b8b08be42)
![4](https://github.com/kangsworkspace/DataStorage/assets/141600830/d22694f7-6693-4451-a485-a88500db64d2)
![5](https://github.com/kangsworkspace/DataStorage/assets/141600830/da4f4072-a466-4ec9-ba85-e4d49c502e4c)

## 🙉 문제점 및 해결

#### 두번째 페이지에서 likeButton을 눌러서 코어 데이터에서 데이터를 지웠을 때 오류가 발생하였습니다.
의도한대로 동작한다면 likeButton을 눌러서 데이터를 삭제하게 된다면 해당 데이터를 담은 Cell이 삭제되어야 합니다.
하지만 image를 비롯한 Cell의 데이터만 삭제되고 Cell 자체는 남아있었습니다.
로그를 찍어 확인해보니 코어 데이터를 삭제하는 코드까지는 정상작동을 하였습니다.
해당 문제는 코어 데이터를 persistentContainer.viewContext에서 삭제하였지만 해당 내용을 영구 저장소에 업데이트 하지 않았기 때문에 발생하였습니다.
코어 데이터를 삭제 후 바로 영구 저장소에 업데이트 하도록 코드를 수정하여 해결하였습니다.
