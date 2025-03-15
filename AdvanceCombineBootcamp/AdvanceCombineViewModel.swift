//
//  AdvanceCombineViewModel.swift
//  AdvanceCombineBootcamp
//
//  Created by Weerawut Chaiyasomboon on 15/03/2568.
//

import Foundation
import Combine

class AdvanceCombineDataService {
    
//    @Published var basicPublisher: String = "First" //this is same as CurrentValueSubject
//    let currentValuePublisher = CurrentValueSubject<String,Error>("First")
    let passThroughPublisher = PassthroughSubject<Int,Error>()
    let boolPublisher = PassthroughSubject<Bool,Error>()
    let intPublisher = PassthroughSubject<Int,Error>()
    
    init() {
        publishFakeData()
    }
    
    private func publishFakeData() {
        let items: [Int] = Array(0..<11)
        for i in items.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
//                self.currentValuePublisher.send(items[i])
//                self.basicPublisher = items[i]
                
                self.passThroughPublisher.send(items[i])
                
                if i > 4 && i < 8 {
                    self.boolPublisher.send(true)
                    self.intPublisher.send(999)
                } else {
                    self.boolPublisher.send(false)
                }
                
                if i == items.indices.last {
                    self.passThroughPublisher.send(completion: .finished)
                }
            }
        }
    }
}

class AdvanceCombineViewModel: ObservableObject {
    @Published var data: [String] = []
    @Published var dataBool: [Bool] = []
    @Published var errorMessage: String = ""
    
    let dataService = AdvanceCombineDataService()
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        addSubcribers()
    }
    
    private func addSubcribers() {
//        dataService.passThroughPublisher
        
        //Sequence operation
//            .first()
//            .first(where: {$0 > 4})
//            .tryFirst(where: { int in
//                if int == 3 {
//                    throw URLError(.badServerResponse)
//                }
//                return int > 4
//            })
//            .last()
//            .last(where: {$0<4})
//            .dropFirst()
//            .dropFirst(3)
//            .drop(while: {$0 < 5})
//            .tryDrop(while: { int in
//                if int == 5 {
//                    throw URLError(.badServerResponse)
//                }
//                return int < 6
//            })
//            .prefix(4)
//            .prefix(while: {$0 < 5})
//            .output(at: 2)
//            .output(in: 2..<4)
            
        //Mathematics operation
//            .max()
//            .max(by: { int1, int2 in
//                return int1 < int2
//            })
//            .min()
        
        //Map/TryMap/CompactMap/Filter/Reduce
//            .map({String($0)})
//            .tryMap({ int in
//                if int == 5 {
//                    throw URLError(.badServerResponse)
//                }
//                return int * 2
//            })
//            .compactMap({ int in
//                if int == 5 {
//                    return nil
//                }
//                return String(int)
//            })
//            .tryCompactMap
//            .filter({$0>3 && $0<7})
//            .tryFilter
//            .removeDuplicates()
//            .replaceNil(with: 5)
//            .replaceEmpty(with: [])
//            .replaceError(with: [])
//            .scan(0, { existingValue, newValue in
//                existingValue + newValue
//            })
//            .scan(0, {$0+$1})
//            .reduce(0, {$0+$1})
//            .collect() //collect to single array and emit
//            .allSatisfy({$0 < 50})
            
        //Timing operation
//            .debounce(for: 1, scheduler: DispatchQueue.main) //delay
//            .delay(for: 2, scheduler: DispatchQueue.main)
//            .measureInterval(using: DispatchQueue.main)
//            .map({ stride in
//                return "\(stride.timeInterval)"
//            })
//            .throttle(for: 5, scheduler: DispatchQueue.main, latest: true)
//            .retry(3)
//            .timeout(5, scheduler: DispatchQueue.main)
        
        //Multiple Publishers/Subcribers
//            .combineLatest(dataService.boolPublisher, dataService.intPublisher)
//            .compactMap({ int,bool in
//                if bool {
//                    return String(int)
//                }
//                return nil
//            })
//            .compactMap({$1 ? String($0) : "n/a"})
//            .removeDuplicates()

//            .compactMap({ int1,bool,int2 in //wait all 3 publishers then execute this
//                if bool {
//                    return String(int1)
//                } 
//                return "n/a"
//            })

//            .merge(with: dataService.intPublisher) //same type of publishers

//            .zip(dataService.boolPublisher, dataService.intPublisher) //return the tuple of publishers, the length is the least number of publisher
//            .map({ tuple in
//                return String(tuple.0) + tuple.1.description + tuple.2.description
//            })
        
//            .tryMap({ int in
//                if int == 5 {
//                    throw URLError(.badServerResponse)
//                }
//                return int
//            })
//            .catch({ error in
//                return self.dataService.intPublisher
//            })
        
        let sharedPublisher = dataService.passThroughPublisher
            .dropFirst(3)
            .share()
        
        sharedPublisher
            .map({String($0)})
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Error get data: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] returnValued in
                self?.data.append(returnValued)
            }
            .store(in: &cancellables)
        
        sharedPublisher
            .map({$0 > 5 ? true : false})
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Error get data: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] returnValue in
                self?.dataBool.append(returnValue)
            }
            .store(in: &cancellables)
    }
}
