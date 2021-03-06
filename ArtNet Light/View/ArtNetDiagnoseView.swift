//
//  ArtNetDiagnoseView.swift
//  ArtNet Light
//
//  Created by Christian Mösl on 29.04.20.
//  Copyright © 2020 Christian Mösl. All rights reserved.
//

import SwiftUI

private struct ArtAddressView: View {
    @EnvironmentObject var artNet: ArtNetMaster
    
    var host: String
    
    @State var netSwitch = 0
    @State var bindIndex = 1
    @State var shortName = ""
    @State var longName = ""
    @State var swIn = [SwitchProgValues](repeating: .noChange, count: 4)
    @State var swOut = [SwitchProgValues](repeating: .noChange, count: 4)
    @State var subSwitch = 0
    @State var command = ArtAddressCommand.none
     

    var body: some View {
        Section(header: Text("Packet")) {
            NumberField("NetSwitch", value: $netSwitch)
            NumberField("BindIndex", value: $bindIndex)
            StringField("ShortName", value: $shortName)
            StringField("LongName", value: $longName)
            ForEach(0..<swIn.count) { idx in
                Picker("SwIn[\(idx + 1)]", selection: self.$swIn[idx]) {
                    ForEach(SwitchProgValues.allCases) { option in
                        Text(option.literal)
                    }
                }
            }
            ForEach(0..<swOut.count) { idx in
                Picker("SwOut[\(idx + 1)]", selection: self.$swOut[idx]) {
                    ForEach(SwitchProgValues.allCases) { option in
                        Text(option.literal)
                    }
                }
            }
            NumberField("SubSwitch", value: $subSwitch)
            Picker("Command", selection: $command) {
                ForEach(ArtAddressCommand.allCases) { option in
                    Text(option.literal)
                }
            }
            Button(action: {
                let params = ArtAddressParameters(
                    net: self.netSwitch,
                    subNet: self.subSwitch,
                    bindIndex: self.bindIndex,
                    shortName: self.shortName,
                    longName: self.longName,
                    swIn: self.swIn,
                    swOut: self.swOut,
                    command: self.command
                )
                self.artNet.sendAddressPacket(to: self.host, with: params)
            }, label: {
                Text("Send")
            })
        }
    }
}

private struct ArtDiagDataView: View {
    var body: some View {
        Text("Diag Data")
    }
}

struct ArtNetDiagnoseView: View {
    @EnvironmentObject var artNet: ArtNetMaster
    
    @State var selection: ArtNetPacketType = .address
    @State var host: String = ""
    
    private var packetTypes: [ArtNetPacketType] = [
        .address
    ]
    
    var body: some View {
        Form {
            Picker("Packet Type", selection: $selection) {
                ForEach(packetTypes, id: \.self) { option in
                    Text(option.literal).tag(option)
                }
            }
            StringField("Destination host", value: $host)
            if selection == .address {
                ArtAddressView(host: host)
            }
        }
    }
}

struct ArtNetDiagnoseView_Previews: PreviewProvider {
    static var previews: some View {
        ArtNetDiagnoseView()
    }
}
