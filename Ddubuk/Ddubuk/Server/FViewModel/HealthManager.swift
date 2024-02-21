import HealthKit

class HealthManager: ObservableObject {
    var healthStore: HKHealthStore?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(false, nil)
            return
        }
        
        healthStore?.requestAuthorization(toShare: [], read: [stepCountType]) { success, error in
            completion(success, error)
            
        }
    }
    
    func readStepCount(startDate: Date, endDate: Date, completion: @escaping (Double, Error?) -> Void) {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(0, nil)
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, statistics, error in
            var steps: Double = 0
            
            if error != nil {
                completion(0, error)
                return
            }
            
            if let quantity = statistics?.sumQuantity() {
                steps = quantity.doubleValue(for: HKUnit.count())
            }
            
            DispatchQueue.main.async {
                completion(steps, nil)
            }
        }
        
        healthStore?.execute(query)
    }
}
