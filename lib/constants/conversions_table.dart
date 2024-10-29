import 'dart:math';

Map<String, Map<String, dynamic>> conversionsMap = {
  'Length': {
    "Millimeters": {
      "unit": "mm",
      "Millimeters": 1,
      "Centimeters": pow(10, -1),
      "Meters": pow(10, -3),
      "Kilometre": pow(10, -6),
      // "Inch":0.0393700787
    },
    "Centimeters": {
      "unit": "cm",
      "Millimeters": 10,
      "Centimeters": 1,
      "Meters": pow(10, -2),
      "Kilometre": pow(10, -5),
    },
    "Meters": {
      "unit": "m",
      "Millimeters": 1000,
      "Centimeters": 100,
      "Meters": 1,
      "Kilometre": pow(10, -3),
    },
    "Kilometre": {
      "unit": "km",
      "Millimeters": 1000000,
      "Centimeters": 100000,
      "Meters": 1000,
      "Kilometre": 1,
    }
  },
  'Mass': {
    "Tons": {
      "unit": "t",
      "Tons": 1,
      "UK Tons": 0.9842065276,
      "US Tons": 1.1023113109,
      "Pounds": 2204.6226218488,
      "Ounces": 35273.96194958,
      "Kilogrammes": pow(10, -3),
      "Grams": pow(10, -6)
    },
    "UK Tons": {
      "unit": "t",
      "Tons": 1.0160469088,
      "UK Tons": 1,
      "US Tons": 1.12,
      "Pounds": 2240,
      "Ounces": 35840,
      "Kilogrammes": 1016.0469088,
      "Grams": 1016046.9088
    },
    "US Tons": {
      "unit": "t",
      "Tons": 0.90718474,
      "UK Tons": 0.8928571429,
      "US Tons": 1,
      "Pounds": 2000,
      "Ounces": 32000,
      "Kilogrammes": 907.18474,
      "Grams": 907184.74
    }
  }
};
