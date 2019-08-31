//
//  ItemListStateTests.swift
//  IoTGardenUITests
//
//  Created by Vinh Nguyen on 8/7/19.
//

import XCTest

class ItemListStateTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let sensor1 = Sensor(uuid: "1234",
                             name: "name1",
                             value: "value1" ,
                             serverUUID: "serverUUID",
                             kind: "kind1",
                             topic: "top1",
                             time: "time1")
        let sensor2 = Sensor(uuid: "456",
                             name: "name1",
                             value: "value1" ,
                             serverUUID: "serverUUID",
                             kind: "kind1",
                             topic: "top1",
                             time: "time1")
        
        var state = ListState
        
        state.sectionItems = [
            .switchSectionItem(viewModel: SwitchCellViewModel(sensor: sensor1)),
            .valueSectionItem(viewModel: InputDevice(sensor: sensor2))
        ]
        let sections: [ItemSectionModel] = [ .itemSection(title: "", items: state.sectionItems)]
        state.sections = sections
        state.identifiableComponent.update()

    }
    
}
