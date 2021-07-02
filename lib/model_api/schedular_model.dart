// To parse this JSON data, do
//
//     final schedular = schedularFromJson(jsonString);

import 'dart:convert';

Schedular schedularFromJson(String ? str) => Schedular.fromJson(json.decode(str!));

String ? schedularToJson(Schedular data) => json.encode(data.toJson());

class Schedular {
    Schedular({
        this.status,
        this.statusMsg,
        this.errorCode,
        this.data,
    });

    String ? status;
    String ? statusMsg;
    dynamic errorCode;
    Data ? data;

    factory Schedular.fromJson(Map<String ?, dynamic> json) => Schedular(
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
        this.employeeList,
    });

    List<Schedule>? employeeList;

    factory Data .fromJson(Map<String ?, dynamic> json) => Data (
        employeeList: List<Schedule>.from(json["Employee List "].map((x) => Schedule.fromJson(x))),
    );

    Map<String ?, dynamic> toJson() => {
        "Employee List ": List<dynamic>.from(employeeList!.map((x) => x.toJson())),
    };
}

class Schedule {
    Schedule({
        this.machineNumber,
        this.currentTime,
        this.shiftType,
        this.currentDate,
        this.machineName,
        this.orderId,
        this.finishedGoodsNumber,
        this.scheduledId,
        this.cablePartNumber,
        this.length,
        this.color,
        this.scheduledQuantity,
        this.scheduledStatus,
        this.process,
        this.awg,
        this.shiftStart,
        this.shiftEnd,
        this.cableNumber,
    });

    dynamic machineNumber;
    dynamic currentTime;
    dynamic shiftType;
    DateTime? currentDate;
    dynamic machineName;
    String ? orderId;
    String ? finishedGoodsNumber;
    String ? scheduledId;
    String ? cablePartNumber;
    String ? length;
    String ? color;
    String ? scheduledQuantity;
    String ? scheduledStatus;
    String ? process;
    int ? awg;
    String ? shiftStart;
    String ? shiftEnd;
    String ? cableNumber;

    factory Schedule.fromJson(Map<String ?, dynamic> json) => Schedule(
        machineNumber: json["machineNumber"],
        currentTime: json["currentTime"],
        shiftType: json["shiftType"],
        currentDate:json["currentDate"]=='0'?DateTime.now(): DateTime.parse(json["currentDate"]??DateTime.now().toString()),
        machineName: json["machineName"],
        orderId: json["orderId"],
        finishedGoodsNumber: json["finishedGoodsNumber"],
        scheduledId: json["scheduledId"],
        cablePartNumber: json["cablePartNumber"],
        length: json["length"],
        color: json["color"],
        scheduledQuantity: json["scheduledQuantity"],
        scheduledStatus: json["scheduledStatus"],
        process: json["process"],
        awg: json["awg"],
        shiftStart: json["shiftStart"],
        shiftEnd: json["shiftEnd"],
        cableNumber: json["cableNumber"],
    );

    Map<String ?, dynamic> toJson() => {
        "machineNumber": machineNumber,
        "currentTime": currentTime,
        "shiftType": shiftType,
        "currentDate": "${currentDate!.year.toString().padLeft(4, '0')}-${currentDate!.month.toString().padLeft(2, '0')}-${currentDate!.day.toString().padLeft(2, '0')}",
        "machineName": machineName,
        "orderId": orderId,
        "finishedGoodsNumber": finishedGoodsNumber,
        "scheduledId": scheduledId,
        "cablePartNumber": cablePartNumber,
        "length": length,
        "color": color,
        "scheduledQuantity": scheduledQuantity,
        "scheduledStatus": scheduledStatus,
        "process": process,
        "awg": awg,
        "shiftStart": shiftStart,
        "shiftEnd": shiftEnd,
        "cableNumber": cableNumber,
    };
}

