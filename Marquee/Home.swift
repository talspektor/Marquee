//
//  Home.swift
//  Marquee
//
//  Created by Tal talspektor on 25/03/2022.
//

import SwiftUI

struct Home: View {
    var body: some View {

        NavigationView {

            VStack(alignment: .leading, spacing: 22) {
                GeometryReader { proxy in

                    let size = proxy.size

                    // MARk: Sample Image
                    Image("computer")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size.width, height: size.height)
                        .cornerRadius(25)
                }
                .frame(height: 200)
                .padding(.horizontal)

                Marquee(text: "Text video games, failed cooking attempts, vlogs and more!", font: .systemFont(ofSize: 16, weight: .regular))
            }

            .navigationTitle("Marquee Text")
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// MARK: Marquee Text View
struct Marquee: View {

    @State var text: String
    // MARK: Customimazation Option
    var font: UIFont

    // Storing Text Size
    @State var storedSize: CGSize = .zero
    // MARK: Animation Offset
    @State var offset: CGFloat = 0

    // MARK: Animation Speed
    var animationSpeed: Double = 0.01
    var delayTime: Double = 0.5

    @Environment(\.colorScheme) var scheme

    var body: some View {
        // Since it scrolls horizontal using Scrollview
        ScrollView(.horizontal, showsIndicators: false) {
            Text(text)
                .font(Font(font))
                .offset(x: offset)
                .padding(.horizontal, 15)
        }
        // MARK: Opacity Effect
        .overlay(content: {

            HStack {

                let color: Color = scheme == .dark ? .black : .white

                LinearGradient(colors: [color, color.opacity(0.7), color.opacity(0.3)], startPoint: .leading, endPoint: .trailing)
                    .frame(width: 20)

                Spacer()

                LinearGradient(colors: [color, color.opacity(0.7), color.opacity(0.3)].reversed(), startPoint: .leading, endPoint: .trailing)
                    .frame(width: 20)
            }
        })
        // Disbaling Manual Scrolling
        .disabled(true)
        .onAppear {


            // Base text
            let baseText = text

            // MARK: Continous Text Animation
            // Adding Spacing for Continous Text
            (1...15).forEach { _ in
                text.append("")
            }
            // Stoping Animation exactly before the next text
            storedSize = textSize()
            text.append(baseText)

            // Calculating Total Secs based on Text Width
            // Our Animation Speed for Each Character will be 0.2
            let timing: Double = (animationSpeed * storedSize.width)

            // Delaying First Animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

                withAnimation(.linear(duration: timing)) {
                    offset = -storedSize.width
                }
            }

        }
        // MARK: Repeating Marquee Effect with the help of Timer
        
        .onReceive(Timer.publish(every: (animationSpeed * storedSize.width) + delayTime, on: .main, in: .default).autoconnect()) { _ in

            // Resetting offset to 0
            // Thus its look its looping
            offset = 0
            withAnimation(.linear(duration: (animationSpeed * storedSize.width))) {
                offset = -storedSize.width
            }

        }
    }

    // MARK: Fetching Text Size for Offset Animation
    func textSize() -> CGSize {

        let attributes = [NSAttributedString.Key.font: font]

        let size = (text as NSString).size(withAttributes: attributes)

        return size
    }
}
