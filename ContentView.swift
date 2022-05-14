//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Maxime on 21/04/2022.
//

import SwiftUI

struct FlagImage: View {
    @State var image: String
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 10)
    }
}

struct Custom: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.blue)
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .shadow(color: .red, radius: 20)
    }
}



extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView: View {
    @State var showingAlert = false
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "USA"]
    @State private var correctAnswer = Int.random(in: 0...3)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var score = 0
    @State private var questions = 0
    @State private var animationAmount = 0.0
    var body: some View {
        ZStack {
            RadialGradient(stops: [.init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                                   .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess The Flag")
                    .titleStyle()
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap flag of ")
                            .font(.subheadline.weight(.heavy))
                            .foregroundColor(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    VStack {
                        ForEach(0..<3) { number in
                            Button {
                                withAnimation {
                                    flapTapped(number)
                                }
                            } label: {
                                FlagImage(image: countries[number])
                                    .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
                            }
                        }
                    }
                }.frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
            
        }.alert(scoreTitle, isPresented: $showingAlert) {
            Button("Continue", action: randomCountry)
        } message: {
            Text(scoreMessage)
        }
    }
    
    func randomCountry() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func flapTapped(_ number: Int) {
        animationAmount += 360
        if (questions != 8) {
            if number == correctAnswer {
                score += 1
                scoreTitle = "Correct"
                scoreMessage = "Your socre is \(score) "
            } else {
                scoreTitle = "Wrong"
                scoreMessage = "Wrong! That's the flag of \(countries[correctAnswer])"
            }
            questions += 1
        } else {
            scoreTitle = "End Game"
            scoreMessage = "Your final score is \(score)"
            score = 0
            questions = 0
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 13")
    }
}
