import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:excel/excel.dart';

class ExcelReader{
  // var file = "Path_to_pre_existing_Excel_File/excel_file.xlsx";
  // var bytes = File(file).readAsBytesSync();
  Excel readXls(bytes){
    Excel excel = Excel.decodeBytes(bytes);
    return excel;
  }

  void clearVendors(Excel excel){
    var newSheetName = "Sheet3_$TimeOfDay.hoursPerDay";
    excel.copy("Sheet3", newSheetName);
    Sheet? sheet = excel.tables["Sheet3"];
    print(excel.tables);
    if(sheet != null){
      var allVendors = new List.empty(growable: true);
      var allPos = new List.empty(growable: true);
      for(var index = 0;index <sheet.maxRows;index++){
        var firstContent = (sheet.row(index).first?.value as String);
        if(firstContent.startsWith("Vendor")){
          bool accepted = firstContent.contains("Singapore") || firstContent.contains("Cambridge");
          allVendors.add(new Vendor(accepted, index));
        }else if(firstContent.startsWith("Purchasing")){
          allPos.add(new PO(firstContent.split(" ")[2], index));
        }

      }
      allVendors = List.from(allVendors.reversed);
      allPos = List.from(allPos.reversed);

      for(var index = sheet.maxRows;index>=0;index--){
        Vendor? vendor = findVendor(allVendors, index);
        if(vendor == null || !vendor.accepted){
          sheet.removeRow(index);
        }else{
          PO? po = findPO(allPos, index);
          if(po != null){
            sheet.updateCell(CellIndex.indexByString("A$index"), po.poNumber);
          }else{
            sheet.removeRow(index);
          }
        }
      }
      printExcel(excel);
    }
    
  }

  void printExcel(Excel excel){
    for (var table in excel.tables.keys) {
      print(table); //sheet Name
      print(excel.tables[table]?.maxCols);
      print(excel.tables[table]?.maxRows);
      for (var row in excel.tables[table]!.rows) {
        var list = new List.empty(growable: true);
        for( Data? data in row) {
          list.add(data?.value);
        }
        print(list);
      }
    }
  }

  Vendor? findVendor(List vendors,int index){
    return null;
  }
  PO? findPO(List pos,int index){
    return null;
  }
}
class Vendor{
  
  bool accepted;
  int index;

  Vendor(this.accepted, this.index);
}
class PO{

  String poNumber;
  int index;

  PO(this.poNumber, this.index);
}