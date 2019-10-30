//
//  ContentView.swift
//  BetterRest
//
//  Created by Levit Kanner on 30/10/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    //PROPERTIES
    @State private var wakeTime = Date()
    @State private var coffeeAmount = 0
    @State private var sleepAmount = 8.0
    
    @State private var isAlertShowing = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    //BODY DEFINITION
    var body: some View {
        NavigationView{
            
            VStack(spacing: 10){
                Text("Set time to wake up")
                    .font(.headline)
                DatePicker(selection: $wakeTime , displayedComponents: .hourAndMinute ) {
                    Text("Wake time")
                }
                .labelsHidden()
                
                Text("Desired amount of sleep")
                    .font(.headline
                )
                Stepper(value: $sleepAmount, in: 4...12 , step: 0.25) {
                    Text("\(sleepAmount , specifier: "%g")")
                }
                Text("Cups of coffee per day")
                    .font(.headline)
                Stepper(value: $coffeeAmount, in: 0...10) {
                    if coffeeAmount == 1 {
                        Text("\(coffeeAmount) cup")
                    }else{
                      Text("\(coffeeAmount) cups")
                    }
                    
                }
            }
        .navigationBarTitle("BetterRest")
            .navigationBarItems(trailing: Button(action: calculateBedTime){
                Text("Calculate")
                    .alert(isPresented: $isAlertShowing) { () -> Alert in
                        Alert(title:Text("\(alertTitle)"), message: Text("\(alertMessage)"), dismissButton: .default(Text("Cancel")))
                }
            })
        }
    }
    
    
    //METHODS
    func calculateBedTime(){
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour , .minute], from: wakeTime)
        let hour = (components.hour ?? 0 ) * 3600
        let minute = (components.minute ?? 0) * 60
        
        do{
            let prediction = try? model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeTime - prediction!.actualSleep  //subtracts a double from a date and returns a date
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "The ideal bedtime is "
            
        }catch{
            alertTitle = "Error"
            alertMessage = "Sorry, there was an error calculating your bedtime"
        }
        
        isAlertShowing = true
        
    }
}
    




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}