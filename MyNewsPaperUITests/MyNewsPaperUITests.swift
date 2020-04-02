//
//  MyNewsPaperUITests.swift
//  MyNewsPaperUITests
//
//  Created by 박성영 on 18/03/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import XCTest

class MyNewsPaperUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func test_UIrecording(){
        
       /*
        let app = XCUIApplication()
        let newstableviewidentifierTable = app.tables["newsTableViewIdentifier"]
        newstableviewidentifierTable/*@START_MENU_TOKEN@*/.staticTexts["/  '투표  /  2일  /  55개국  /  "]/*[[".cells[\"newsCell_0\"].staticTexts[\"\/  '투표  \/  2일  \/  55개국  \/  \"]",".staticTexts[\"\/  '투표  \/  2일  \/  55개국  \/  \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let mynewspaperButton = app.navigationBars["MyNewsPaper.NewsItemView"].buttons["MyNewsPaper"]
        mynewspaperButton.tap()
        newstableviewidentifierTable/*@START_MENU_TOKEN@*/.staticTexts["경찰 \"조주빈과 박사방 공동운영 3명 중 2명 이미 검거\" - YTN"]/*[[".cells[\"newsCell_1\"].staticTexts[\"경찰 \\\"조주빈과 박사방 공동운영 3명 중 2명 이미 검거\\\" - YTN\"]",".staticTexts[\"경찰 \\\"조주빈과 박사방 공동운영 3명 중 2명 이미 검거\\\" - YTN\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        mynewspaperButton.tap()
        newstableviewidentifierTable/*@START_MENU_TOKEN@*/.staticTexts["[골목길에서 본 2020 총선]④​서울 광진을 ‘민주당 아성’ 이번에는? 20~30대 “오 후보, 올드 이미지” 60대 “고 후보, 연고 없는 낙하산”   낙후된 지역 개발 변수? 아파트 민주-주상복합 한국당 우세 민주당 찍어온 40대 “개발에 한 표”   후보보다 전국적 이슈? “조국·경제심판 위해 야당” 지적에 “위기 때 여당 힘 실어줘야” 반론도"]/*[[".cells[\"newsCell_2\"].staticTexts[\"[골목길에서 본 2020 총선]④​서울 광진을 ‘민주당 아성’ 이번에는? 20~30대 “오 후보, 올드 이미지” 60대 “고 후보, 연고 없는 낙하산”   낙후된 지역 개발 변수? 아파트 민주-주상복합 한국당 우세 민주당 찍어온 40대 “개발에 한 표”   후보보다 전국적 이슈? “조국·경제심판 위해 야당” 지적에 “위기 때 여당 힘 실어줘야” 반론도\"]",".staticTexts[\"[골목길에서 본 2020 총선]④​서울 광진을 ‘민주당 아성’ 이번에는? 20~30대 “오 후보, 올드 이미지” 60대 “고 후보, 연고 없는 낙하산”   낙후된 지역 개발 변수? 아파트 민주-주상복합 한국당 우세 민주당 찍어온 40대 “개발에 한 표”   후보보다 전국적 이슈? “조국·경제심판 위해 야당” 지적에 “위기 때 여당 힘 실어줘야” 반론도\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        mynewspaperButton.tap()
        newstableviewidentifierTable/*@START_MENU_TOKEN@*/.staticTexts["‘채널A-검찰 유착의혹’ 보도한 장인수 MBC 기자“녹취록 정리하면서 틀릴 수 있어 녹음파일 원본 공개” MBC 뉴스데스크 캡처채널A 법조팀 A기자와 검찰 고위직 간의 유착 의혹을 제기한 MBC 뉴스데스크가 취재 과.."]/*[[".cells[\"newsCell_3\"].staticTexts[\"‘채널A-검찰 유착의혹’ 보도한 장인수 MBC 기자“녹취록 정리하면서 틀릴 수 있어 녹음파일 원본 공개” MBC 뉴스데스크 캡처채널A 법조팀 A기자와 검찰 고위직 간의 유착 의혹을 제기한 MBC 뉴스데스크가 취재 과..\"]",".staticTexts[\"‘채널A-검찰 유착의혹’ 보도한 장인수 MBC 기자“녹취록 정리하면서 틀릴 수 있어 녹음파일 원본 공개” MBC 뉴스데스크 캡처채널A 법조팀 A기자와 검찰 고위직 간의 유착 의혹을 제기한 MBC 뉴스데스크가 취재 과..\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        mynewspaperButton.tap()
        */
    }
    
    
    
    
    func test_TableviewCellResultAvailable() {
        // UI tests must launch the application that they test.
        let tableView = app.tables.matching(identifier: "newsTableViewIdentifier")
        let cell = tableView.cells.element(matching: .cell, identifier: "newsCell_0")
        cell.tap()
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
