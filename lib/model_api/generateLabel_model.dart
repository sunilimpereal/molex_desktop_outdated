// To parse this JSON data, do
//
//     final postGenerateLabel = postGenerateLabelFromJson(jsonString);

import 'dart:convert';

PostGenerateLabel postGenerateLabelFromJson(String ? str) => PostGenerateLabel.fromJson(json.decode(str!));

String ? postGenerateLabelToJson(PostGenerateLabel data) => json.encode(data.toJson());

class PostGenerateLabel {
    PostGenerateLabel({
       required this.finishedGoods,
       required this.purchaseorder,
       required this.orderIdentification,
       required this.cablePartNumber,
       required this.cutLength,
       required this.color,
       required this.scheduleIdentification,
       required this.scheduledQuantity,
       required this.machineIdentification,
       required this.operatorIdentification,
       required this.bundleIdentification,
       required this.rejectedQuantity,
       required this.terminalDamage,
       required this.terminalBend,
       required this.terminalTwist,
       required this.conductorCurlingUpDown,
       required this.insulationCurlingUpDown,
       required this.conductorBurr,
       required this.windowGap,
       required this.crimpOnInsulation,
       required this.improperCrimping,
       required this.tabBendOrTabOpen,
       required this.bellMouthLessOrMore,
       required this.cutOffLessOrMore,
       required this.cutOffBurr,
       required this.cutOffBend,
       required this.insulationDamage,
       required this.exposureStrands,
       required this.strandsCut,
       required this.brushLengthLessorMore,
       required this.terminalCoppermark,
       required this.setupRejections,
       required this.terminalBackOut,
       required this.cableDamage,
       required this.crimpingPositionOutOrMissCrimp,
       required this.terminalSeamOpen,
       required this.rollerMark,
       required this.lengthLessOrLengthMore,
       required this.gripperMark,
       required this.endWire,
       required this.endTerminal,
       required this.entangledCable,
       required this.troubleShootingRejections,
       required this.wireOverLoadRejectionsJam,
       required this.halfCurlingA,
       required this.brushLengthLessOrMoreC,
       required this.exposureStrandsD,
       required this.cameraPositionOutE,
       required this.crimpOnInsulationF,
       required this.cablePositionMovementG,
       required this.crimpOnInsulationC,
       required this.crimpingPositionOutOrMissCrimpD,
       required this.crimpPositionOut,
       required this.stripPositionOut,
       required this.offCurling,
       required this.cFmPfmRejections,
       required this.incomingIssue,
       required this.bladeMark,
       required this.crossCut,
       required this.insulationBarrel,
       required this.method,
       required this.terminalFrom,
       required this.terminalTo,
       required this.awg
    });

    int  finishedGoods;
    int  purchaseorder;
    int  orderIdentification;
    int  cablePartNumber;
    int  cutLength;
    String  color;
    int  scheduleIdentification;
    int  scheduledQuantity;
    String  machineIdentification;
    String  operatorIdentification;
    String  bundleIdentification;
    int  rejectedQuantity;
    int  terminalDamage;
    int  terminalBend;
    int  terminalTwist;
    int  conductorCurlingUpDown;
    int  insulationCurlingUpDown;
    int  conductorBurr;
    int  windowGap;
    int  crimpOnInsulation;
    int  improperCrimping;
    int  tabBendOrTabOpen;
    int  bellMouthLessOrMore;
    int  cutOffLessOrMore;
    int  cutOffBurr;
    int  cutOffBend;
    int  insulationDamage;
    int  exposureStrands;
    int  strandsCut;
    int  brushLengthLessorMore;
    int  terminalCoppermark;
    int  setupRejections;
    int  terminalBackOut;
    int  cableDamage;
    int  crimpingPositionOutOrMissCrimp;
    int  terminalSeamOpen;
    int  rollerMark;
    int  lengthLessOrLengthMore;
    int  gripperMark;
    int  endWire;
    int  endTerminal;
    int  entangledCable;
    int  troubleShootingRejections;
    int  wireOverLoadRejectionsJam;
    int  halfCurlingA;
    int  brushLengthLessOrMoreC;
    int  exposureStrandsD;
    int  cameraPositionOutE;
    int  crimpOnInsulationF;
    int  cablePositionMovementG;
    int  crimpOnInsulationC;
    int  crimpingPositionOutOrMissCrimpD;
    int  crimpPositionOut;
    int  stripPositionOut;
    int  offCurling;
    int  cFmPfmRejections;
    int  incomingIssue;
    int  bladeMark;
    int  crossCut;
    int  insulationBarrel;
    String  method;
    int ? terminalFrom;
    int ? terminalTo;
    String ? awg;

    factory PostGenerateLabel.fromJson(Map<String ?, dynamic> json) => PostGenerateLabel(
        finishedGoods: json["finishedGoods"],
        purchaseorder: json["purchaseorder"],
        orderIdentification: json["orderIdentification"],
        cablePartNumber: json["cablePartNumber"],
        cutLength: json["cutLength"],
        color: json["color"],
        scheduleIdentification: json["scheduleIdentification"],
        scheduledQuantity: json["scheduledQuantity"],
        machineIdentification: json["machineIdentification"],
        operatorIdentification: json["operatorIdentification"],
        bundleIdentification: json["bundleIdentification"],
        rejectedQuantity: json["rejectedQuantity"],
        terminalDamage: json["terminalDamage"],
        terminalBend: json["terminalBend"],
        terminalTwist: json["terminalTwist"],
        conductorCurlingUpDown: json["conductorCurlingUpDown"],
        insulationCurlingUpDown: json["insulationCurlingUpDown"],
        conductorBurr: json["conductorBurr"],
        windowGap: json["windowGap"],
        crimpOnInsulation: json["crimpOnInsulation"],
        improperCrimping: json["improperCrimping"],
        tabBendOrTabOpen: json["tabBendOrTabOpen"],
        bellMouthLessOrMore: json["bellMouthLessOrMore"],
        cutOffLessOrMore: json["cutOffLessOrMore"],
        cutOffBurr: json["cutOffBurr"],
        cutOffBend: json["cutOffBend"],
        insulationDamage: json["insulationDamage"],
        exposureStrands: json["exposureStrands"],
        strandsCut: json["strandsCut"],
        brushLengthLessorMore: json["brushLengthLessorMore"],
        terminalCoppermark: json["terminalCoppermark"],
        setupRejections: json["setupRejections"],
        terminalBackOut: json["terminalBackOut"],
        cableDamage: json["cableDamage"],
        crimpingPositionOutOrMissCrimp: json["crimpingPositionOutOrMissCrimp"],
        terminalSeamOpen: json["terminalSeamOpen"],
        rollerMark: json["rollerMark"],
        lengthLessOrLengthMore: json["lengthLessOrLengthMore"],
        gripperMark: json["gripperMark"],
        endWire: json["endWire"],
        endTerminal: json["endTerminal"],
        entangledCable: json["entangledCable"],
        troubleShootingRejections: json["troubleShootingRejections"],
        wireOverLoadRejectionsJam: json["wireOverLoadRejectionsJam"],
        halfCurlingA: json["halfCurling_A"],
        brushLengthLessOrMoreC: json["brushLengthLessOrMore_C"],
        exposureStrandsD: json["exposureStrands_D"],
        cameraPositionOutE: json["cameraPositionOut_E"],
        crimpOnInsulationF: json["crimpOnInsulation_F"],
        cablePositionMovementG: json["cablePositionMovement_G"],
        crimpOnInsulationC: json["crimpOnInsulation_C"],
        crimpingPositionOutOrMissCrimpD: json["crimpingPositionOutOrMissCrimp_D"],
        crimpPositionOut: json["crimpPositionOut"],
        stripPositionOut: json["stripPositionOut"],
        offCurling: json["offCurling"],
        cFmPfmRejections: json["cFM_PFM_Rejections"],
        incomingIssue: json["incomingIssue"],
        bladeMark: json["bladeMark"],
        crossCut: json["crossCut"],
        insulationBarrel: json["insulationBarrel"],
        method: json["method"],
        terminalFrom: json["terminalFrom"],
        terminalTo: json["terminalTo"],
        awg: json["awg"],
    );

    Map<String ?, dynamic> toJson() => {
        "finishedGoods": finishedGoods,
        "purchaseorder": purchaseorder,
        "orderIdentification": orderIdentification,
        "cablePartNumber": cablePartNumber,
        "cutLength": cutLength,
        "color": color,
        "scheduleIdentification": scheduleIdentification,
        "scheduledQuantity": scheduledQuantity,
        "machineIdentification": machineIdentification,
        "operatorIdentification": operatorIdentification,
        "bundleIdentification": bundleIdentification,
        "rejectedQuantity": rejectedQuantity,
        "terminalDamage": terminalDamage,
        "terminalBend": terminalBend,
        "terminalTwist": terminalTwist,
        "conductorCurlingUpDown": conductorCurlingUpDown,
        "insulationCurlingUpDown": insulationCurlingUpDown,
        "conductorBurr": conductorBurr,
        "windowGap": windowGap,
        "crimpOnInsulation": crimpOnInsulation,
        "improperCrimping": improperCrimping,
        "tabBendOrTabOpen": tabBendOrTabOpen,
        "bellMouthLessOrMore": bellMouthLessOrMore,
        "cutOffLessOrMore": cutOffLessOrMore,
        "cutOffBurr": cutOffBurr,
        "cutOffBend": cutOffBend,
        "insulationDamage": insulationDamage,
        "exposureStrands": exposureStrands,
        "strandsCut": strandsCut,
        "brushLengthLessorMore": brushLengthLessorMore,
        "terminalCoppermark": terminalCoppermark,
        "setupRejections": setupRejections,
        "terminalBackOut": terminalBackOut,
        "cableDamage": cableDamage,
        "crimpingPositionOutOrMissCrimp": crimpingPositionOutOrMissCrimp,
        "terminalSeamOpen": terminalSeamOpen,
        "rollerMark": rollerMark,
        "lengthLessOrLengthMore": lengthLessOrLengthMore,
        "gripperMark": gripperMark,
        "endWire": endWire,
        "endTerminal": endTerminal,
        "entangledCable": entangledCable,
        "troubleShootingRejections": troubleShootingRejections,
        "wireOverLoadRejectionsJam": wireOverLoadRejectionsJam,
        "halfCurling_A": halfCurlingA,
        "brushLengthLessOrMore_C": brushLengthLessOrMoreC,
        "exposureStrands_D": exposureStrandsD,
        "cameraPositionOut_E": cameraPositionOutE,
        "crimpOnInsulation_F": crimpOnInsulationF,
        "cablePositionMovement_G": cablePositionMovementG,
        "crimpOnInsulation_C": crimpOnInsulationC,
        "crimpingPositionOutOrMissCrimp_D": crimpingPositionOutOrMissCrimpD,
        "crimpPositionOut": crimpPositionOut,
        "stripPositionOut": stripPositionOut,
        "offCurling": offCurling,
        "cFM_PFM_Rejections": cFmPfmRejections,
        "incomingIssue": incomingIssue,
        "bladeMark": bladeMark,
        "crossCut": crossCut,
        "insulationBarrel": insulationBarrel,
        "method": method,
        "terminalFrom": terminalFrom,
        "terminalTo": terminalTo,
        "awg": awg,
    };
}


// To parse this JSON data, do
//
//     final responseGenerateLabel = responseGenerateLabelFromJson(jsonString);



// To parse this JSON data, do
//
//     final responseGenerateLabel = responseGenerateLabelFromJson(jsonString);


ResponseGenerateLabel responseGenerateLabelFromJson(String ? str) => ResponseGenerateLabel.fromJson(json.decode(str!));

String ? responseGenerateLabelToJson(ResponseGenerateLabel data) => json.encode(data.toJson());

class ResponseGenerateLabel {
    ResponseGenerateLabel({
        this.status,
        this.statusMsg,
        this.errorCode,
        this.data,
    });

    String ? status;
    String ? statusMsg;
    dynamic errorCode;
    Data ? data;

    factory ResponseGenerateLabel.fromJson(Map<String ?, dynamic> json) => ResponseGenerateLabel(
        status: json["status"],
        statusMsg: json["statusMsg"],
        errorCode: json["errorCode"],
        data: Data .fromJson(json["data"]),
    );

    Map<String ?, dynamic> toJson() => {
        "status": status,
        "statusMsg": statusMsg,
        "errorCode": errorCode,
        "data": data?.toJson(),
    };
}

class Data  {
    Data ({
        this.generateLabel,
    });

    GeneratedLabel? generateLabel;

    factory Data.fromJson(Map<String ?, dynamic> json) => Data(
        generateLabel: GeneratedLabel.fromJson(json[" Generate Label "]),
    );

    Map<String ?, dynamic> toJson() => {
        " Generate Label ": generateLabel!.toJson(),
    };
}

class GeneratedLabel {
    GeneratedLabel({
        this.finishedGoods,
        this.cablePartNumber,
        this.cutLength,
        this.wireGauge,
        this.terminalFrom,
        this.terminalTo,
        this.bundleQuantity,
        this.routeNo,
        this.bundleId,
        this.status,
    });

    int ? finishedGoods;
    int ? cablePartNumber;
    int ? cutLength;
    String ? wireGauge;
    int ? terminalFrom;
    int ? terminalTo;
    int ? bundleQuantity;
    String ? routeNo;
    String ? bundleId;
    int ? status;

    factory GeneratedLabel.fromJson(Map<String ?, dynamic> json) => GeneratedLabel(
        finishedGoods: json["finishedGoods"],
        cablePartNumber: json["cablePartNumber"],
        cutLength: json["cutLength"],
        wireGauge: json["wireGauge"],
        terminalFrom: json["terminalFrom"],
        terminalTo: json["terminalTo"],
        bundleQuantity: json["bundleQuantity"],
        routeNo: json["routeNo"],
        bundleId: json["bundleId"],
        status: json["status"],
    );

    Map<String ?, dynamic> toJson() => {
        "finishedGoods": finishedGoods,
        "cablePartNumber": cablePartNumber,
        "cutLength": cutLength,
        "wireGauge": wireGauge,
        "terminalFrom": terminalFrom,
        "terminalTo": terminalTo,
        "bundleQuantity": bundleQuantity,
        "routeNo": routeNo,
        "bundleId": bundleId,
        "status": status,
    };
}

// To parse this JSON data, do
//
//     final errorGenerateLabel = errorGenerateLabelFromJson(jsonString);



ErrorGenerateLabel errorGenerateLabelFromJson(String ? str) => ErrorGenerateLabel.fromJson(json.decode(str!));

String ? errorGenerateLabelToJson(ErrorGenerateLabel data) => json.encode(data.toJson());

class ErrorGenerateLabel {
    ErrorGenerateLabel({
        this.status,
        this.statusMsg,
        this.errorCode,
        required this.data,
    });

    String ? status;
    String ? statusMsg;
    String ? errorCode;
    Data1 data;

    factory ErrorGenerateLabel.fromJson(Map<String ?, dynamic> json) => ErrorGenerateLabel(
        status: json["status"],
        statusMsg: json["statusMsg"],
        errorCode: json["errorCode"],
        data: Data1.fromJson(json["data"]),
    );

    Map<String ?, dynamic> toJson() => {
        "status": status,
        "statusMsg": statusMsg,
        "errorCode": errorCode,
        "data": data.toJson(),
    };
}

class Data1 {
    Data1();

    factory Data1.fromJson(Map<String ?, dynamic> json) => Data1(
    );

    Map<String ?, dynamic> toJson() => {
    };
}
