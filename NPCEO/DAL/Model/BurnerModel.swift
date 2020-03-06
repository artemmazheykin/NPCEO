//
//  BurnerModel.swift
//  NPCEO
//
//  Created by Artem Mazheykin on 03.03.2020.
//  Copyright © 2020 Artem Mazheykin. All rights reserved.
//

import Foundation

enum BurnerStandartCapacity{

    case pointFifty,one,onepointFifty,two,twoPointFifty,three,threePointFifty,four,fourPointFifty,five,fivePointFifty,six,other(Double)
    
    var inMw: Double{
        switch self {
        case .pointFifty:
            return 0.5
        case .one:
            return 1.0
        case .onepointFifty:
            return 1.5
        case .two:
            return 2.0
        case .twoPointFifty:
            return 2.5
        case .three:
            return 3.0
        case .threePointFifty:
            return 3.5
        case .four:
            return 4.0
        case .fourPointFifty:
            return 4.5
        case .five:
            return 5.0
        case .fivePointFifty:
            return 5.5
        case .six:
            return 6.0
        case .other(let otherCapacity):
            return otherCapacity
        }
    }
    
    var burnerTypeSize: Double{
        return inMw*10
    }
}

enum BurnerName{
    case gkvd, gnvm, gki, gks, gkst, gdk, gkdt, gkp, pg, pz, ggi, ggu, ggr, gins
}

class BurnerIdentifiers{
    static let allTypes:[String] = [BurnerTypeName.gkvd.imageName,BurnerTypeName.nastil.imageName,BurnerTypeName.dut.imageName,BurnerTypeName.inzh.imageName,BurnerTypeName.ggi.imageName,BurnerTypeName.trubcol.imageName]
    static let allTypeNames:[String] = [BurnerTypeName.gkvd.typeName,BurnerTypeName.nastil.typeName,BurnerTypeName.dut.typeName,BurnerTypeName.inzh.typeName,BurnerTypeName.ggi.typeName,BurnerTypeName.trubcol.typeName]
}

enum BurnerTypeName{
    case gkvd, nastil, dut, inzh, ggi, trubcol
    
    var imageName:String{
        switch self {
        case .gkvd:
            return "gkvd.jpg"
        case .nastil:
            return "nast.jpg"
        case .dut:
            return "dut.jpg"
        case .inzh:
            return "inzh.jpg"
        case .ggi:
            return "ggi.jpg"
        case .trubcol:
            return "trubcol.jpg"
        }
    }
    
    var typeName: String{
        switch self {
        case .gkvd:
            return "Инжекционно-дутьевые горелки ГКВД"
        case .nastil:
        return "Настильные горелки"
        case .dut:
            return "Дутьевые горелки"
        case .inzh:
            return "Инжекционные горелки"
        case .ggi:
            return "Горелки с предварительным смешением"
        case .trubcol:
            return "Горелки с трубчатым коллектором"
        }
    }
}

class BurnerModel{
    
    private let burnerStandartCapacity: BurnerStandartCapacity
    var burnerName: BurnerName
    var burnerTypeSize: Double{
        return burnerStandartCapacity.burnerTypeSize
    }
    var burnerNominalCapacity: Double
    var nominalFlowRate: (mazutInKgCh: Double?, vaporInKgCh: Double?, naturalGasInM3Ch: Double?, airInM3Ch: Double?)
    var nominalPressure: (mazutInMPa: Double?, vaporInMPa: Double?, naturalGasInkPa: Double?, airInPa: Double?)
    var koefWorkReg: (onMazut: Double?, onGas: Double?)
    var koefExcessAir: (onMazut: Double?, onGas: Double?)
    var airExhaustionInPa: Double
    var vaporToMazutInKgKg: Double
    var nomFlameLengthInMeters: (onMazut: Double?, onGas: Double?)
    var contentOfCOInPercetVol: (onMazut: Double?, onGas: Double?)
    var contentNOXInMgM3: (onMazut: Double?, onGas: Double?)
    var generatedVolumeOfSoundIndB: Double
    var sizesInMm: (length: Double?, width: Double?, hight: Double?)
    var weightInKg: Int
    var nominGasPressureOnPGInKPa: Double
    var nominalGasFlowRateOnPGInM3Ch: Double
    var firstOverhaulPeriodInThousHours: Int
    var lifeServiceInYears: Int
    
    
    init(burnerStandartCapacity: BurnerStandartCapacity, burnerName: BurnerName, burnerNominalCapacity: Double, nominalFlowRate: (mazutInKgCh: Double?, vaporInKgCh: Double?, naturalGasInM3Ch: Double?, airInM3Ch: Double?), nominalPressure: (mazutInMPa: Double?, vaporInMPa: Double?, naturalGasInkPa: Double?, airInPa: Double?), koefWorkReg: (onMazut: Double?, onGas: Double?), koefExcessAir: (onMazut: Double?, onGas: Double?), airExhaustionInPa: Double, vaporToMazutInKgKg: Double, nomFlameLengthInMeters: (onMazut: Double?, onGas: Double?), contentOfCOInPercetVol: (onMazut: Double?, onGas: Double?), contentNOXInMgM3: (onMazut: Double?, onGas: Double?), generatedVolumeOfSoundIndB: Double, sizesInMm: (length: Double?, width: Double?, hight: Double?), weightInKg: Int, nominGasPressureOnPGInKPa: Double, nominalGasFlowRateOnPGInM3Ch: Double, firstOverhaulPeriodInThousHours: Int, lifeServiceInYears: Int) {
        self.burnerStandartCapacity = burnerStandartCapacity
        self.burnerName = burnerName
        self.burnerNominalCapacity = burnerNominalCapacity
        self.nominalFlowRate = nominalFlowRate
        self.nominalPressure = nominalPressure
        self.koefWorkReg = koefWorkReg
        self.koefExcessAir = koefExcessAir
        self.airExhaustionInPa = airExhaustionInPa
        self.vaporToMazutInKgKg = vaporToMazutInKgKg
        self.nomFlameLengthInMeters = nomFlameLengthInMeters
        self.contentOfCOInPercetVol = contentOfCOInPercetVol
        self.contentNOXInMgM3 = contentNOXInMgM3
        self.generatedVolumeOfSoundIndB = generatedVolumeOfSoundIndB
        self.sizesInMm = sizesInMm
        self.weightInKg = weightInKg
        self.nominGasPressureOnPGInKPa = nominGasPressureOnPGInKPa
        self.nominalGasFlowRateOnPGInM3Ch = nominalGasFlowRateOnPGInM3Ch
        self.firstOverhaulPeriodInThousHours = firstOverhaulPeriodInThousHours
        self.lifeServiceInYears = lifeServiceInYears
    }
}
