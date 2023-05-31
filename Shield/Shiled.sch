EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "Encoder Shield"
Date "09-13-21"
Rev "Version 1"
Comp "LUCI, LLC"
Comment1 "Designed by Christian"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text Label 8950 1450 1    60   ~ 0
Vin
Text Label 9350 1450 1    60   ~ 0
IOREF
Text Label 8900 2500 0    60   ~ 0
A0
Text Label 8900 2600 0    60   ~ 0
A1
Text Label 8900 2700 0    60   ~ 0
A2
Text Label 8900 2800 0    60   ~ 0
A3
Text Label 8900 2900 0    60   ~ 0
A4(SDA)
Text Label 8900 3000 0    60   ~ 0
A5(SCL)
Text Label 10550 3000 0    60   ~ 0
0(Rx)
Text Label 10550 2800 0    60   ~ 0
2
Text Label 10550 2900 0    60   ~ 0
1(Tx)
Text Label 10550 2700 0    60   ~ 0
3(**)
Text Label 10550 2600 0    60   ~ 0
4
Text Label 10550 2500 0    60   ~ 0
5(**)
Text Label 10550 2400 0    60   ~ 0
6(**)
Text Label 10550 2300 0    60   ~ 0
7
Text Label 10550 2100 0    60   ~ 0
8
Text Label 10550 2000 0    60   ~ 0
9(**)
Text Label 10550 1900 0    60   ~ 0
10(**/SS)
Text Label 10550 1800 0    60   ~ 0
11(**/MOSI)
Text Label 10550 1700 0    60   ~ 0
12(MISO)
Text Label 10550 1600 0    60   ~ 0
13(SCK)
Text Label 10550 1400 0    60   ~ 0
AREF
NoConn ~ 9400 1600
Text Label 10550 1300 0    60   ~ 0
A4(SDA)
Text Label 10550 1200 0    60   ~ 0
A5(SCL)
Text Notes 10850 1000 0    60   ~ 0
Holes
Text Notes 8550 750  0    60   ~ 0
Shield for Arduino that uses\nthe same pin disposition\nlike "Uno" board Rev 3.
$Comp
L Connector_Generic:Conn_01x08 P1
U 1 1 56D70129
P 9600 1900
F 0 "P1" H 9600 2350 50  0000 C CNN
F 1 "Power" V 9700 1900 50  0000 C CNN
F 2 "Socket_Arduino_Uno:Socket_Strip_Arduino_1x08" V 9750 1900 20  0000 C CNN
F 3 "" H 9600 1900 50  0000 C CNN
	1    9600 1900
	1    0    0    -1  
$EndComp
Text Label 8650 1800 0    60   ~ 0
Reset
$Comp
L power:+3.3V #PWR01
U 1 1 56D70538
P 9150 1450
F 0 "#PWR01" H 9150 1300 50  0001 C CNN
F 1 "+3.3V" V 9150 1700 50  0000 C CNN
F 2 "" H 9150 1450 50  0000 C CNN
F 3 "" H 9150 1450 50  0000 C CNN
	1    9150 1450
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR02
U 1 1 56D707BB
P 9050 1350
F 0 "#PWR02" H 9050 1200 50  0001 C CNN
F 1 "+5V" V 9050 1550 50  0000 C CNN
F 2 "" H 9050 1350 50  0000 C CNN
F 3 "" H 9050 1350 50  0000 C CNN
	1    9050 1350
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR03
U 1 1 56D70CC2
P 9300 3150
F 0 "#PWR03" H 9300 2900 50  0001 C CNN
F 1 "GND" H 9300 3000 50  0000 C CNN
F 2 "" H 9300 3150 50  0000 C CNN
F 3 "" H 9300 3150 50  0000 C CNN
	1    9300 3150
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR04
U 1 1 56D70CFF
P 10300 3150
F 0 "#PWR04" H 10300 2900 50  0001 C CNN
F 1 "GND" H 10300 3000 50  0000 C CNN
F 2 "" H 10300 3150 50  0000 C CNN
F 3 "" H 10300 3150 50  0000 C CNN
	1    10300 3150
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_01x06 P2
U 1 1 56D70DD8
P 9600 2700
F 0 "P2" H 9600 2300 50  0000 C CNN
F 1 "Analog" V 9700 2700 50  0000 C CNN
F 2 "Socket_Arduino_Uno:Socket_Strip_Arduino_1x06" V 9750 2750 20  0000 C CNN
F 3 "" H 9600 2700 50  0000 C CNN
	1    9600 2700
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_01x01 P5
U 1 1 56D71177
P 10800 650
F 0 "P5" V 10900 650 50  0000 C CNN
F 1 "CONN_01X01" V 10900 650 50  0001 C CNN
F 2 "Socket_Arduino_Uno:Arduino_1pin" H 10721 724 20  0000 C CNN
F 3 "" H 10800 650 50  0000 C CNN
	1    10800 650 
	0    -1   -1   0   
$EndComp
$Comp
L Connector_Generic:Conn_01x01 P6
U 1 1 56D71274
P 10900 650
F 0 "P6" V 11000 650 50  0000 C CNN
F 1 "CONN_01X01" V 11000 650 50  0001 C CNN
F 2 "Socket_Arduino_Uno:Arduino_1pin" H 10900 650 20  0001 C CNN
F 3 "" H 10900 650 50  0000 C CNN
	1    10900 650 
	0    -1   -1   0   
$EndComp
$Comp
L Connector_Generic:Conn_01x01 P7
U 1 1 56D712A8
P 11000 650
F 0 "P7" V 11100 650 50  0000 C CNN
F 1 "CONN_01X01" V 11100 650 50  0001 C CNN
F 2 "Socket_Arduino_Uno:Arduino_1pin" V 11000 650 20  0001 C CNN
F 3 "" H 11000 650 50  0000 C CNN
	1    11000 650 
	0    -1   -1   0   
$EndComp
$Comp
L Connector_Generic:Conn_01x01 P8
U 1 1 56D712DB
P 11100 650
F 0 "P8" V 11200 650 50  0000 C CNN
F 1 "CONN_01X01" V 11200 650 50  0001 C CNN
F 2 "Socket_Arduino_Uno:Arduino_1pin" H 11024 572 20  0000 C CNN
F 3 "" H 11100 650 50  0000 C CNN
	1    11100 650 
	0    -1   -1   0   
$EndComp
NoConn ~ 10800 850 
NoConn ~ 10900 850 
NoConn ~ 11000 850 
NoConn ~ 11100 850 
$Comp
L Connector_Generic:Conn_01x08 P4
U 1 1 56D7164F
P 10000 2600
F 0 "P4" H 10000 2100 50  0000 C CNN
F 1 "Digital" V 10100 2600 50  0000 C CNN
F 2 "Socket_Arduino_Uno:Socket_Strip_Arduino_1x08" V 10150 2550 20  0000 C CNN
F 3 "" H 10000 2600 50  0000 C CNN
	1    10000 2600
	-1   0    0    -1  
$EndComp
Wire Notes Line
	8525 825  9925 825 
Wire Notes Line
	9925 825  9925 475 
Wire Wire Line
	9350 1450 9350 1700
Wire Wire Line
	9350 1700 9400 1700
Wire Wire Line
	9400 1900 9150 1900
Wire Wire Line
	9400 2000 9050 2000
Wire Wire Line
	9400 2300 8950 2300
Wire Wire Line
	9400 2100 9300 2100
Wire Wire Line
	9400 2200 9300 2200
Connection ~ 9300 2200
Wire Wire Line
	8950 2300 8950 1450
Wire Wire Line
	9050 2000 9050 1350
Wire Wire Line
	9150 1900 9150 1450
Wire Wire Line
	9400 2500 8900 2500
Wire Wire Line
	9400 2600 8900 2600
Wire Wire Line
	9400 2700 8900 2700
Wire Wire Line
	9400 2800 8900 2800
Wire Wire Line
	9400 2900 8900 2900
Wire Wire Line
	9400 3000 8900 3000
$Comp
L Connector_Generic:Conn_01x10 P3
U 1 1 56D721E0
P 10000 1600
F 0 "P3" H 10000 2150 50  0000 C CNN
F 1 "Digital" V 10100 1600 50  0000 C CNN
F 2 "Socket_Arduino_Uno:Socket_Strip_Arduino_1x10" V 10150 1600 20  0000 C CNN
F 3 "" H 10000 1600 50  0000 C CNN
	1    10000 1600
	-1   0    0    -1  
$EndComp
Wire Wire Line
	10200 2100 10550 2100
Wire Wire Line
	10200 2000 10550 2000
Wire Wire Line
	10200 1900 10550 1900
Wire Wire Line
	10200 1800 10550 1800
Wire Wire Line
	10200 1700 10550 1700
Wire Wire Line
	10200 1600 10550 1600
Wire Wire Line
	10200 1400 10550 1400
Wire Wire Line
	10200 1300 10550 1300
Wire Wire Line
	10200 1200 10550 1200
Wire Wire Line
	10200 3000 10550 3000
Wire Wire Line
	10200 2900 10550 2900
Wire Wire Line
	10200 2800 10550 2800
Wire Wire Line
	10200 2700 10550 2700
Wire Wire Line
	10200 2600 10550 2600
Wire Wire Line
	10200 2500 10550 2500
Wire Wire Line
	10200 2400 10550 2400
Wire Wire Line
	10200 2300 10550 2300
Wire Wire Line
	10200 1500 10300 1500
Wire Wire Line
	10300 1500 10300 3150
Wire Wire Line
	9300 2100 9300 2200
Wire Wire Line
	9300 2200 9300 3150
Wire Notes Line
	8500 500  8500 3450
Wire Notes Line
	8500 3450 11200 3450
Wire Wire Line
	9400 1800 8650 1800
Text Notes 9700 1600 0    60   ~ 0
1
Wire Notes Line
	11200 1000 10700 1000
Wire Notes Line
	10700 1000 10700 500 
$Comp
L Connector:Screw_Terminal_01x02 E1
U 1 1 613E6DE6
P 3885 900
F 0 "E1" H 3965 892 50  0000 L CNN
F 1 "FL_caster" H 3965 801 50  0000 L CNN
F 2 "TerminalBlock_Phoenix:TerminalBlock_Phoenix_MPT-0,5-2-2.54_1x02_P2.54mm_Horizontal" H 3885 900 50  0001 C CNN
F 3 "~" H 3885 900 50  0001 C CNN
	1    3885 900 
	1    0    0    -1  
$EndComp
$Comp
L Connector:Screw_Terminal_01x02 E2
U 1 1 613E71AF
P 3885 1160
F 0 "E2" H 3965 1152 50  0000 L CNN
F 1 "L_wheel" H 3965 1061 50  0000 L CNN
F 2 "TerminalBlock_Phoenix:TerminalBlock_Phoenix_MPT-0,5-2-2.54_1x02_P2.54mm_Horizontal" H 3885 1160 50  0001 C CNN
F 3 "~" H 3885 1160 50  0001 C CNN
	1    3885 1160
	1    0    0    -1  
$EndComp
$Comp
L Connector:Screw_Terminal_01x02 E5
U 1 1 613E7F4F
P 4995 910
F 0 "E5" H 5075 902 50  0000 L CNN
F 1 "R_wheel" H 5075 811 50  0000 L CNN
F 2 "TerminalBlock_Phoenix:TerminalBlock_Phoenix_MPT-0,5-2-2.54_1x02_P2.54mm_Horizontal" H 4995 910 50  0001 C CNN
F 3 "~" H 4995 910 50  0001 C CNN
	1    4995 910 
	1    0    0    -1  
$EndComp
$Comp
L Connector:Screw_Terminal_01x02 E6
U 1 1 613E85A7
P 4985 1160
F 0 "E6" H 5065 1152 50  0000 L CNN
F 1 "FR_caster" H 5065 1061 50  0000 L CNN
F 2 "TerminalBlock_Phoenix:TerminalBlock_Phoenix_MPT-0,5-2-2.54_1x02_P2.54mm_Horizontal" H 4985 1160 50  0001 C CNN
F 3 "~" H 4985 1160 50  0001 C CNN
	1    4985 1160
	1    0    0    -1  
$EndComp
$Comp
L Connector:Screw_Terminal_01x02 J1
U 1 1 613EA9CE
P 1460 5230
F 0 "J1" H 1540 5222 50  0000 L CNN
F 1 "Power_1" H 1540 5131 50  0000 L CNN
F 2 "TerminalBlock_Phoenix:TerminalBlock_Phoenix_MPT-0,5-2-2.54_1x02_P2.54mm_Horizontal" H 1460 5230 50  0001 C CNN
F 3 "~" H 1460 5230 50  0001 C CNN
	1    1460 5230
	1    0    0    -1  
$EndComp
Text GLabel 1260 5230 0    50   Input ~ 0
+5V
$Comp
L power:GND #PWR0101
U 1 1 613F5E03
P 1260 5330
F 0 "#PWR0101" H 1260 5080 50  0001 C CNN
F 1 "GND" H 1260 5180 50  0000 C CNN
F 2 "" H 1260 5330 50  0000 C CNN
F 3 "" H 1260 5330 50  0000 C CNN
	1    1260 5330
	1    0    0    -1  
$EndComp
$Comp
L Connector:Screw_Terminal_01x02 J2
U 1 1 613FB6F6
P 1470 5700
F 0 "J2" H 1550 5692 50  0000 L CNN
F 1 "Power_2" H 1550 5601 50  0000 L CNN
F 2 "TerminalBlock_Phoenix:TerminalBlock_Phoenix_MPT-0,5-2-2.54_1x02_P2.54mm_Horizontal" H 1470 5700 50  0001 C CNN
F 3 "~" H 1470 5700 50  0001 C CNN
	1    1470 5700
	1    0    0    -1  
$EndComp
Text GLabel 1270 5700 0    50   Input ~ 0
+5V
$Comp
L power:GND #PWR05
U 1 1 613FB6FD
P 1270 5800
F 0 "#PWR05" H 1270 5550 50  0001 C CNN
F 1 "GND" H 1270 5650 50  0000 C CNN
F 2 "" H 1270 5800 50  0000 C CNN
F 3 "" H 1270 5800 50  0000 C CNN
	1    1270 5800
	1    0    0    -1  
$EndComp
$Comp
L Connector:Screw_Terminal_01x02 J4
U 1 1 613FC6A6
P 1480 6100
F 0 "J4" H 1560 6092 50  0000 L CNN
F 1 "Power_3" H 1560 6001 50  0000 L CNN
F 2 "TerminalBlock_Phoenix:TerminalBlock_Phoenix_MPT-0,5-2-2.54_1x02_P2.54mm_Horizontal" H 1480 6100 50  0001 C CNN
F 3 "~" H 1480 6100 50  0001 C CNN
	1    1480 6100
	1    0    0    -1  
$EndComp
Text GLabel 1280 6100 0    50   Input ~ 0
+5V
$Comp
L power:GND #PWR07
U 1 1 613FC6AD
P 1280 6200
F 0 "#PWR07" H 1280 5950 50  0001 C CNN
F 1 "GND" H 1280 6050 50  0000 C CNN
F 2 "" H 1280 6200 50  0000 C CNN
F 3 "" H 1280 6200 50  0000 C CNN
	1    1280 6200
	1    0    0    -1  
$EndComp
$Comp
L Connector:Screw_Terminal_01x02 J3
U 1 1 613FD686
P 1470 6500
F 0 "J3" H 1550 6492 50  0000 L CNN
F 1 "Power_4" H 1550 6401 50  0000 L CNN
F 2 "TerminalBlock_Phoenix:TerminalBlock_Phoenix_MPT-0,5-2-2.54_1x02_P2.54mm_Horizontal" H 1470 6500 50  0001 C CNN
F 3 "~" H 1470 6500 50  0001 C CNN
	1    1470 6500
	1    0    0    -1  
$EndComp
Text GLabel 1270 6500 0    50   Input ~ 0
+5V
$Comp
L power:GND #PWR06
U 1 1 613FD68D
P 1270 6600
F 0 "#PWR06" H 1270 6350 50  0001 C CNN
F 1 "GND" H 1270 6450 50  0000 C CNN
F 2 "" H 1270 6600 50  0000 C CNN
F 3 "" H 1270 6600 50  0000 C CNN
	1    1270 6600
	1    0    0    -1  
$EndComp
$Comp
L Connector:Screw_Terminal_01x02 J5
U 1 1 613FE5D7
P 1490 6860
F 0 "J5" H 1570 6852 50  0000 L CNN
F 1 "Power_5" H 1570 6761 50  0000 L CNN
F 2 "TerminalBlock_Phoenix:TerminalBlock_Phoenix_MPT-0,5-2-2.54_1x02_P2.54mm_Horizontal" H 1490 6860 50  0001 C CNN
F 3 "~" H 1490 6860 50  0001 C CNN
	1    1490 6860
	1    0    0    -1  
$EndComp
Text GLabel 1290 6860 0    50   Input ~ 0
+5V
$Comp
L power:GND #PWR08
U 1 1 613FE5DE
P 1290 6960
F 0 "#PWR08" H 1290 6710 50  0001 C CNN
F 1 "GND" H 1290 6810 50  0000 C CNN
F 2 "" H 1290 6960 50  0000 C CNN
F 3 "" H 1290 6960 50  0000 C CNN
	1    1290 6960
	1    0    0    -1  
$EndComp
Text GLabel 1090 1380 0    50   Input ~ 0
A4(SDA)
Text GLabel 1090 1470 0    50   Input ~ 0
A5(SCL)
Text GLabel 920  1180 0    50   Input ~ 0
+5V
$Comp
L power:GND #PWR09
U 1 1 6140B821
P 1260 1280
F 0 "#PWR09" H 1260 1030 50  0001 C CNN
F 1 "GND" H 1260 1130 50  0000 C CNN
F 2 "" H 1260 1280 50  0000 C CNN
F 3 "" H 1260 1280 50  0000 C CNN
	1    1260 1280
	0    1    1    0   
$EndComp
Wire Wire Line
	1260 1280 1325 1280
Wire Wire Line
	1090 1380 1325 1380
Wire Wire Line
	1090 1470 1325 1470
Wire Wire Line
	1325 1470 1325 1480
$Comp
L Shiled-rescue:TCA9548A-Adafruit-TCA9548 U1
U 1 1 613E43B9
P 1675 1480
F 0 "U1" H 1675 2095 50  0000 C CNN
F 1 "TCA9548A" H 1675 2004 50  0000 C CNN
F 2 "Adafruit-TCA9548A:TCA9548A" H 1675 1530 50  0001 C CNN
F 3 "" H 1675 1530 50  0001 C CNN
	1    1675 1480
	1    0    0    -1  
$EndComp
Wire Wire Line
	920  1180 1325 1180
Text GLabel 985  1970 0    50   Input ~ 0
SD0
Text GLabel 985  2075 0    50   Input ~ 0
SC0
Text GLabel 980  2190 0    50   Input ~ 0
SD1
Text GLabel 980  2290 0    50   Input ~ 0
SC1
Text GLabel 2175 2290 2    50   Input ~ 0
SD2
Text GLabel 2175 2185 2    50   Input ~ 0
SC2
Text GLabel 2185 2075 2    50   Input ~ 0
SD3
Text GLabel 2185 1970 2    50   Input ~ 0
SC3
Text GLabel 2190 1865 2    50   Input ~ 0
SD4
Text GLabel 2190 1755 2    50   Input ~ 0
SC4
Wire Wire Line
	985  1970 1325 1970
Wire Wire Line
	1325 1970 1325 1980
Wire Wire Line
	985  2075 1325 2075
Wire Wire Line
	1325 2075 1325 2080
Wire Wire Line
	980  2190 1325 2190
Wire Wire Line
	1325 2190 1325 2180
Wire Wire Line
	980  2290 1325 2290
Wire Wire Line
	1325 2290 1325 2280
Wire Wire Line
	2025 1780 2190 1780
Wire Wire Line
	2190 1780 2190 1755
Wire Wire Line
	2025 1880 2190 1880
Wire Wire Line
	2190 1880 2190 1865
Wire Wire Line
	2025 1980 2185 1980
Wire Wire Line
	2185 1980 2185 1970
Wire Wire Line
	2025 2080 2185 2080
Wire Wire Line
	2185 2080 2185 2075
Wire Wire Line
	2025 2180 2175 2180
Wire Wire Line
	2175 2180 2175 2185
Wire Wire Line
	2025 2280 2175 2280
Wire Wire Line
	2175 2280 2175 2290
Text GLabel 3595 900  0    50   Input ~ 0
SD0
Text GLabel 3595 1000 0    50   Input ~ 0
SC0
Text GLabel 3595 1160 0    50   Input ~ 0
SD1
Text GLabel 3595 1260 0    50   Input ~ 0
SC1
Text GLabel 3595 1420 0    50   Input ~ 0
SD2
Text GLabel 3595 1690 0    50   Input ~ 0
SD3
Text GLabel 3595 1790 0    50   Input ~ 0
SC3
Text GLabel 4655 1010 0    50   Input ~ 0
SC4
Text GLabel 4655 910  0    50   Input ~ 0
SD4
Text GLabel 2190 1560 2    50   Input ~ 0
SC5
Text GLabel 2200 1650 2    50   Input ~ 0
SD5
Wire Wire Line
	2025 1580 2190 1580
Wire Wire Line
	2190 1580 2190 1560
Wire Wire Line
	2025 1680 2200 1680
Wire Wire Line
	2200 1680 2200 1650
Text GLabel 4655 1260 0    50   Input ~ 0
SC5
Text GLabel 4655 1160 0    50   Input ~ 0
SD5
$Comp
L Device:LED D1
U 1 1 6146A960
P 5485 3465
F 0 "D1" H 5478 3682 50  0000 C CNN
F 1 "LED" H 5478 3591 50  0000 C CNN
F 2 "LED_THT:LED_D5.0mm" H 5485 3465 50  0001 C CNN
F 3 "~" H 5485 3465 50  0001 C CNN
	1    5485 3465
	1    0    0    -1  
$EndComp
$Comp
L Device:R R3
U 1 1 6146B11F
P 5025 3615
F 0 "R3" H 5095 3661 50  0000 L CNN
F 1 "330" H 5095 3570 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 4955 3615 50  0001 C CNN
F 3 "~" H 5025 3615 50  0001 C CNN
	1    5025 3615
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR012
U 1 1 61471313
P 5025 3835
F 0 "#PWR012" H 5025 3585 50  0001 C CNN
F 1 "GND" H 5025 3685 50  0000 C CNN
F 2 "" H 5025 3835 50  0000 C CNN
F 3 "" H 5025 3835 50  0000 C CNN
	1    5025 3835
	1    0    0    -1  
$EndComp
Text GLabel 5745 3465 2    50   Input ~ 0
12(MISO)
Text GLabel 3695 3475 0    50   Input ~ 0
+5V
$Comp
L Device:R R2
U 1 1 6145401D
P 4365 3695
F 0 "R2" H 4435 3741 50  0000 L CNN
F 1 "10K" H 4435 3650 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 4295 3695 50  0001 C CNN
F 3 "~" H 4365 3695 50  0001 C CNN
	1    4365 3695
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_DIP_x01 SW1
U 1 1 614172D4
P 4065 3475
F 0 "SW1" H 4065 3742 50  0000 C CNN
F 1 "SW_DIP_x01" H 4065 3651 50  0000 C CNN
F 2 "Button_Switch_SMD:SW_DIP_SPSTx01_Slide_Copal_CHS-01B_W7.62mm_P1.27mm" H 4065 3475 50  0001 C CNN
F 3 "~" H 4065 3475 50  0001 C CNN
	1    4065 3475
	1    0    0    -1  
$EndComp
Text GLabel 4485 3475 2    50   Input ~ 0
4
Wire Wire Line
	3695 3475 3765 3475
Wire Wire Line
	4365 3475 4485 3475
Wire Wire Line
	4365 3545 4365 3475
Connection ~ 4365 3475
$Comp
L power:GND #PWR0102
U 1 1 614348D6
P 4365 3905
F 0 "#PWR0102" H 4365 3655 50  0001 C CNN
F 1 "GND" H 4365 3755 50  0000 C CNN
F 2 "" H 4365 3905 50  0000 C CNN
F 3 "" H 4365 3905 50  0000 C CNN
	1    4365 3905
	1    0    0    -1  
$EndComp
Wire Wire Line
	4365 3845 4365 3905
Wire Wire Line
	5025 3465 5335 3465
Wire Wire Line
	5635 3465 5745 3465
Wire Wire Line
	5025 3765 5025 3835
Wire Wire Line
	3595 900  3685 900 
Wire Wire Line
	3595 1000 3685 1000
Wire Wire Line
	3595 1160 3685 1160
Wire Wire Line
	3595 1260 3685 1260
Text GLabel 3595 1520 0    50   Input ~ 0
SC2
$Comp
L Connector:Screw_Terminal_01x02 E3
U 1 1 613E76AC
P 3885 1420
F 0 "E3" H 3965 1412 50  0000 L CNN
F 1 "BL_caster" H 3965 1321 50  0000 L CNN
F 2 "TerminalBlock_Phoenix:TerminalBlock_Phoenix_MPT-0,5-2-2.54_1x02_P2.54mm_Horizontal" H 3885 1420 50  0001 C CNN
F 3 "~" H 3885 1420 50  0001 C CNN
	1    3885 1420
	1    0    0    -1  
$EndComp
Wire Wire Line
	3595 1420 3685 1420
Wire Wire Line
	3595 1520 3685 1520
$Comp
L Connector:Screw_Terminal_01x02 E4
U 1 1 613E7A8F
P 3885 1690
F 0 "E4" H 3965 1682 50  0000 L CNN
F 1 "BR_caster" H 3965 1591 50  0000 L CNN
F 2 "TerminalBlock_Phoenix:TerminalBlock_Phoenix_MPT-0,5-2-2.54_1x02_P2.54mm_Horizontal" H 3885 1690 50  0001 C CNN
F 3 "~" H 3885 1690 50  0001 C CNN
	1    3885 1690
	1    0    0    -1  
$EndComp
Wire Wire Line
	3595 1690 3685 1690
Wire Wire Line
	3595 1790 3685 1790
Wire Wire Line
	4655 910  4795 910 
Wire Wire Line
	4655 1010 4795 1010
Wire Wire Line
	4655 1160 4785 1160
Wire Wire Line
	4655 1260 4785 1260
Wire Notes Line
	470  2760 2930 2760
Wire Notes Line
	2930 2760 2930 470 
Text Notes 580  610  0    50   ~ 0
I2C Multiplexer
Wire Notes Line
	3135 550  5615 550 
Wire Notes Line
	5615 550  5615 2020
Wire Notes Line
	5615 2020 3135 2020
Wire Notes Line
	3135 2020 3135 550 
Text Notes 3205 660  0    50   ~ 0
Encoders
Wire Notes Line
	3205 4265 6435 4265
Wire Notes Line
	6435 4265 6435 3085
Wire Notes Line
	6435 3085 3205 3085
Wire Notes Line
	3205 3085 3205 4265
Text Notes 3245 3185 0    50   ~ 0
Feedback\n
Wire Notes Line
	470  4620 2360 4620
Wire Notes Line
	2360 4620 2360 7790
Text Notes 570  4770 0    50   ~ 0
Power\n
$Comp
L Connector:Screw_Terminal_01x02 J6
U 1 1 614261CC
P 1485 7250
F 0 "J6" H 1565 7242 50  0000 L CNN
F 1 "Power_6" H 1565 7151 50  0000 L CNN
F 2 "TerminalBlock_Phoenix:TerminalBlock_Phoenix_MPT-0,5-2-2.54_1x02_P2.54mm_Horizontal" H 1485 7250 50  0001 C CNN
F 3 "~" H 1485 7250 50  0001 C CNN
	1    1485 7250
	1    0    0    -1  
$EndComp
Text GLabel 1285 7250 0    50   Input ~ 0
+5V
$Comp
L power:GND #PWR010
U 1 1 614261D3
P 1285 7350
F 0 "#PWR010" H 1285 7100 50  0001 C CNN
F 1 "GND" H 1285 7200 50  0000 C CNN
F 2 "" H 1285 7350 50  0000 C CNN
F 3 "" H 1285 7350 50  0000 C CNN
	1    1285 7350
	1    0    0    -1  
$EndComp
$EndSCHEMATC
