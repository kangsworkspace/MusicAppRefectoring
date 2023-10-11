//
//  MusicManager.swift
//  MusicAppRefectoring
//
//  Created by Kang on 2023/10/09.
//

import UIKit

final class MusicManager {
    
    // 싱글톤으로 만들기
    static let shared = MusicManager()

    // 초기화 할 때 저장된 데이터 셋팅
    private init() {
        fetchMusicFromCoreData {
            print("저장된 데이터 셋팅 완료")
        }
    }

    // 네트워크 매니저(싱글톤)
    private let networkManager = NetworkManager.shared

    // 코어데이터 매니저(싱글톤)
    private let coreDataManager = CoreDataManager.shared

    // 서버에서 받아온 음악 배열
    private var musicArrays: [Music] = []

    // 코어데이터에 저장하기 위한 음악 배열
    private var musicSavedArrays: [MusicSaved] = []

    func getMusicArraysFromAPI() -> [Music] {
        return musicArrays
    }

    func getMusicDatasFromCoreData() -> [MusicSaved] {
        print("\(musicSavedArrays.count)")
        return musicSavedArrays
    }

    // [네트워킹] - 데이터 셋업하기
    func setupDatasFromAPI(completion: @escaping () -> Void) {
        print("초기 데이터: zazz")
        getDatasFromAPI(with: "zazz") {
            completion()
        }
    }

    // [네트워킹] - 특정 단어로 검색
    func fetchDatasFromAPI(with searchTerm: String, completion: @escaping () -> Void) {
        getDatasFromAPI(with: searchTerm) {
            completion()
        }
    }

    // [네트워킹] - 서버에서 데이터 가져오기
    private func getDatasFromAPI(with searchTerm: String, completion: @escaping () -> Void) {
        networkManager.fetchMusic(searchTerm: searchTerm) { result in
            switch result {
            case .success(let musicDatas):
                self.musicArrays = musicDatas
                self.checkWhetherSaved()
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                self.checkWhetherSaved()
                completion()
            }
        }
    }

    // [코어데이터] - 초기 데이터 셋업
    private func setupDatasFromCoreData(completion: () -> Void) {
        // [READ]
        fetchMusicFromCoreData {
            completion()
        }
    }

    // [코어데이터] - 코어데이터에서 데이터 가져오기(READ)
    private func fetchMusicFromCoreData(completion: () -> Void) {
        musicSavedArrays = coreDataManager.getMusicSavedArrayFromCoreData()
        print("fetchMusicFromCoreData 성공")
        completion()
    }

    // [코어데이터] - 코어데이터 데이터 생성하기(CREATE)
    func saveMusicData(with music: Music, message: String?, completion: @escaping () -> Void) {
        coreDataManager.saveMusic(with: music, message: message) {
            self.fetchMusicFromCoreData {
                print("saveMusicData 성공")
                completion()
            }
        }
    }
    
    // [코어데이터] - 삭제(Music타입을 가지고 데이터 지우기) ==> 저장되어 있는지 확인하고 지우기
    func deleteMusic(with music: Music, completion: @escaping () -> Void) {
                
        // 동일한 데이터 찾아내기
        let musicSaved = musicSavedArrays.filter { $0.songName == music.songName && $0.artistName == music.artistName }
        
        // 데이터 전달
        if let targetMusicSaved = musicSaved.first {
            // [DELETE]
            self.deleteMusicFromCoreData(with: targetMusicSaved) {
                
                completion()
            }
        } else {
            print("삭제 실패")
            completion()
        }
    }

    // [코어데이터] - 코어데이터 데이터 삭제하기, MusicSaved타입을 가지고 데이터 지우기(DELETE)
    func deleteMusicFromCoreData(with music: MusicSaved, completion: @escaping () -> Void) {
        coreDataManager.deleteMusic(with: music) {
            self.fetchMusicFromCoreData {
                self.checkWhetherSaved()
                print("deleteMusicFromCoreData - 동작완료")
                completion()
            }
        }
    }

    // [코어데이터] - 코어데이터 데이터 수정(UPDATE)
    func updateMusicToCoreData(with music: MusicSaved, completion: @escaping () -> Void) {
        coreDataManager.updateMusic(with: music) {
            self.fetchMusicFromCoreData {
                completion()
            }
        }
    }

    // 이미 저장된 데이터들인지 확인
    func checkWhetherSaved() {
        musicArrays.forEach { music in
            //코어데이터에 저장된 것들 중 음악 및 가수 이름이 같은 것 찾아내서
            if musicSavedArrays.contains(where: {
                $0.songName == music.songName && $0.artistName == music.artistName
            }) {
                // 이미 저장되어있는 데이터라고 설정
                music.isSaved = true
            } else {
                music.isSaved = false
            }
        }
    }
}
