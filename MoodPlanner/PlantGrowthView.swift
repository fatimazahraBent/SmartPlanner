import SwiftUI

struct PlantGrowthView: View {
    var progress: Double

    var body: some View {
        Image(imageNameForProgress(progress))
            .resizable()
            .scaledToFit()
            .shadow(radius: 5)
    }

    func imageNameForProgress(_ progress: Double) -> String {
        if progress >= 1.0 {
            return "plant_stage4"
        } else if progress >= 0.7 {
            return "plant_stage3"
        } else if progress >= 0.3 {
            return "plant_stage2"
        } else {
            return "plant_stage1"
        }
    }
}
