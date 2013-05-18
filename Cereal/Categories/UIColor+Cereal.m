//
//  UIColor+Cereal.m
//  Cereal
//
//  Created by Joshua Gretz on 1/27/11.
//
/* Copyright 2011 TrueFit Solutions
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <UIKit/UIKit.h>

@implementation UIColor(Cereal)

// kept this around because it was too much work to change all of the custom colors
static UIColor* calculateColorWithAlpha(float r, float g, float b, float a) {
    return [UIColor colorWithRed: r / 255.0f green: g / 255.0f blue: b / 255.0f alpha: a];
};

static UIColor* calculateColor(float r, float g, float b) {
    return calculateColorWithAlpha(r, g, b, 1);
};

-(NSString*) toString {
    float red, green, blue, alpha;
    [self getRed: &red green: &green blue: &blue alpha: &alpha];

    return [NSString stringWithFormat: @"%f,%f,%f,%f", red, green, blue, alpha];
}

+(UIColor*) fromString: (NSString*) value {
    NSArray* stringComponents = [value componentsSeparatedByString: @","];
    if (stringComponents.count < 3)
        return nil;

    float red = [stringComponents[0] floatValue];
    float green = [stringComponents[1] floatValue];
    float blue = [stringComponents[2] floatValue];
    float alpha = stringComponents.count >= 4 ? [stringComponents[3] floatValue] : 1;

    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+(UIColor*) fromHex: (NSString*) value {
    return [UIColor fromHex: value alpha: 1];
}

+(UIColor*) fromHex: (NSString*) value alpha: (float) alpha {
    unsigned int hexInt = 0;

    NSScanner* scanner = [NSScanner scannerWithString: value];

    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped: [NSCharacterSet characterSetWithCharactersInString: @"#"]];
    [scanner scanHexInt: &hexInt];

    // Create color object, specifying alpha as well
    UIColor* color = [UIColor colorWithRed: ((CGFloat)((hexInt & 0xFF0000) >> 16)) / 255 green: ((CGFloat)((hexInt & 0xFF00) >> 8)) / 255 blue: ((CGFloat)(hexInt & 0xFF)) / 255 alpha: alpha];

    return color;
}

-(NSString*) toHex {
    float red, green, blue, alpha;
    [self getRed: &red green: &green blue: &blue alpha: &alpha];

    return [NSString stringWithFormat: @"%02X%02X%02X", (uint) red, (uint) green, (uint) blue];
}

+(UIColor*) vendColorWithRed: (CGFloat) r green: (CGFloat) g blue: (CGFloat) b {
    return calculateColor(r, g, b);
}

+(UIColor*) vendColorWithRed: (CGFloat) r green: (CGFloat) g blue: (CGFloat) b alpha: (CGFloat) a {
    return calculateColorWithAlpha(r, g, b, a);
}

+(UIColor*) aliceBlue {
    return calculateColor(240, 248, 255);
}

+(UIColor*) alizarin {
    return calculateColor(227, 38, 54);
}

+(UIColor*) amaranth {
    return calculateColor(229, 43, 80);
}

+(UIColor*) amber {
    return calculateColor(255, 191, 0);
}

+(UIColor*) amethyst {
    return calculateColor(153, 102, 204);
}

+(UIColor*) apricot {
    return calculateColor(251, 206, 177);
}

+(UIColor*) aqua {
    return calculateColor(0, 255, 255);
}

+(UIColor*) aquamarine {
    return calculateColor(127, 255, 212);
}

+(UIColor*) armyGreen {
    return calculateColor(75, 83, 32);
}

+(UIColor*) asparagus {
    return calculateColor(123, 160, 91);
}

+(UIColor*) atomicTangerine {
    return calculateColor(255, 153, 102);
}

+(UIColor*) auburn {
    return calculateColor(111, 53, 26);
}

+(UIColor*) azure {
    return calculateColor(0, 127, 255);
}

+(UIColor*) azureWeb {
    return calculateColor(240, 255, 255);
}

+(UIColor*) babyBlue {
    return calculateColor(224, 255, 255);
}

+(UIColor*) beige {
    return calculateColor(245, 245, 220);
}

+(UIColor*) bistre {
    return calculateColor(61, 43, 31);
}

+(UIColor*) black {
    return calculateColor(0, 0, 0);
}

+(UIColor*) blue {
    return calculateColor(0, 0, 255);
}

+(UIColor*) pigmentBlue {
    return calculateColor(51, 51, 153);
}

+(UIColor*) rybBlue {
    return calculateColor(2, 71, 254);
}

+(UIColor*) blueGreen {
    return calculateColor(0, 223, 223);
}

+(UIColor*) blueViolet {
    return calculateColor(138, 43, 226);
}

+(UIColor*) bondiBlue {
    return calculateColor(0, 149, 182);
}

+(UIColor*) brass {
    return calculateColor(181, 166, 66);
}

+(UIColor*) brightGreen {
    return calculateColor(102, 255, 0);
}

+(UIColor*) brightPink {
    return calculateColor(255, 0, 127);
}

+(UIColor*) brightTurquoise {
    return calculateColor(8, 232, 222);
}

+(UIColor*) brilliantRose {
    return calculateColor(255, 85, 163);
}

+(UIColor*) britishRacingGreen {
    return calculateColor(0, 66, 37);
}

+(UIColor*) bronze {
    return calculateColor(205, 127, 50);
}

+(UIColor*) brown {
    return calculateColor(150, 75, 0);
}

+(UIColor*) buff {
    return calculateColor(240, 220, 130);
}

+(UIColor*) burgundy {
    return calculateColor(128, 0, 32);
}

+(UIColor*) burntOrange {
    return calculateColor(204, 85, 0);
}

+(UIColor*) burntSienna {
    return calculateColor(233, 116, 81);
}

+(UIColor*) burntUmber {
    return calculateColor(138, 51, 36);
}

+(UIColor*) camouflageGreen {
    return calculateColor(120, 134, 107);
}

+(UIColor*) caputMortuum {
    return calculateColor(89, 39, 32);
}

+(UIColor*) cardinal {
    return calculateColor(196, 30, 58);
}

+(UIColor*) carmine {
    return calculateColor(150, 0, 24);
}

+(UIColor*) carnationPink {
    return calculateColor(255, 166, 201);
}

+(UIColor*) carolinaBlue {
    return calculateColor(156, 186, 227);
}

+(UIColor*) carrotOrange {
    return calculateColor(237, 145, 33);
}

+(UIColor*) celadon {
    return calculateColor(172, 225, 175);
}

+(UIColor*) cerise {
    return calculateColor(222, 49, 99);
}

+(UIColor*) cerulean {
    return calculateColor(0, 123, 167);
}

+(UIColor*) ceruleanBlue {
    return calculateColor(42, 82, 190);
}

+(UIColor*) champagne {
    return calculateColor(247, 231, 206);
}

+(UIColor*) charcoal {
    return calculateColor(70, 70, 70);
}

+(UIColor*) chartreuse {
    return calculateColor(223, 255, 0);
}

+(UIColor*) chartreuseWeb {
    return calculateColor(127, 255, 0);
}

+(UIColor*) cherryBlossomPink {
    return calculateColor(255, 183, 197);
}

+(UIColor*) chestnut {
    return calculateColor(205, 92, 92);
}

+(UIColor*) chocolate {
    return calculateColor(123, 63, 0);
}

+(UIColor*) cinnabar {
    return calculateColor(227, 66, 52);
}

+(UIColor*) cinnamon {
    return calculateColor(210, 105, 30);
}

+(UIColor*) cobalt {
    return calculateColor(0, 71, 171);
}

+(UIColor*) columbiaBlue {
    return calculateColor(155, 221, 255);
}

+(UIColor*) copper {
    return calculateColor(184, 115, 51);
}

+(UIColor*) copperRose {
    return calculateColor(153, 102, 102);
}

+(UIColor*) coral {
    return calculateColor(255, 127, 80);
}

+(UIColor*) coralRed {
    return calculateColor(255, 64, 64);
}

+(UIColor*) corn {
    return calculateColor(251, 236, 93);
}

+(UIColor*) cornflowerBlue {
    return calculateColor(100, 149, 237);
}

+(UIColor*) cosmicLatte {
    return calculateColor(255, 248, 231);
}

+(UIColor*) cream {
    return calculateColor(255, 253, 208);
}

+(UIColor*) crimson {
    return calculateColor(220, 20, 60);
}

+(UIColor*) cyan {
    return calculateColor(0, 255, 255);
}

+(UIColor*) processCyan {
    return calculateColor(0, 180, 247);
}

+(UIColor*) darkBlue {
    return calculateColor(0, 0, 139);
}

+(UIColor*) darkBrown {
    return calculateColor(101, 67, 33);
}

+(UIColor*) darkCerulean {
    return calculateColor(8, 69, 126);
}

+(UIColor*) darkChestnut {
    return calculateColor(152, 105, 96);
}

+(UIColor*) darkCoral {
    return calculateColor(205, 91, 69);
}

+(UIColor*) darkGoldenrod {
    return calculateColor(184, 134, 11);
}

+(UIColor*) darkGreen {
    return calculateColor(1, 50, 32);
}

+(UIColor*) darkKhaki {
    return calculateColor(189, 183, 107);
}

+(UIColor*) darkPastelGreen {
    return calculateColor(3, 192, 60);
}

+(UIColor*) darkPink {
    return calculateColor(231, 84, 128);
}

+(UIColor*) darkScarlet {
    return calculateColor(86, 3, 125);
}

+(UIColor*) darkSalmon {
    return calculateColor(233, 150, 122);
}

+(UIColor*) darkSlateGray {
    return calculateColor(47, 79, 79);
}

+(UIColor*) darkSpringGreen {
    return calculateColor(23, 114, 69);
}

+(UIColor*) darkTan {
    return calculateColor(145, 129, 81);
}

+(UIColor*) darkTurquoise {
    return calculateColor(0, 206, 209);
}

+(UIColor*) darkViolet {
    return calculateColor(148, 0, 211);
}

+(UIColor*) deepCerise {
    return calculateColor(218, 50, 135);
}

+(UIColor*) deepChestnut {
    return calculateColor(185, 78, 72);
}

+(UIColor*) deepFuchsia {
    return calculateColor(193, 84, 193);
}

+(UIColor*) deepLilac {
    return calculateColor(153, 85, 187);
}

+(UIColor*) deepMagenta {
    return calculateColor(204, 0, 204);
}

+(UIColor*) deepPeach {
    return calculateColor(255, 203, 164);
}

+(UIColor*) deepPink {
    return calculateColor(255, 20, 147);
}

+(UIColor*) denim {
    return calculateColor(21, 96, 189);
}

+(UIColor*) dodgerBlue {
    return calculateColor(30, 144, 255);
}

+(UIColor*) ecru {
    return calculateColor(194, 178, 128);
}

+(UIColor*) egyptianBlue {
    return calculateColor(16, 52, 166);
}

+(UIColor*) electricBlue {
    return calculateColor(125, 249, 255);
}

+(UIColor*) electricGreen {
    return calculateColor(0, 255, 0);
}

+(UIColor*) electricIndigo {
    return calculateColor(102, 0, 255);
}

+(UIColor*) electricLime {
    return calculateColor(204, 255, 0);
}

+(UIColor*) electricPurple {
    return calculateColor(191, 0, 255);
}

+(UIColor*) emerald {
    return calculateColor(80, 200, 120);
}

+(UIColor*) eggplant {
    return calculateColor(97, 64, 81);
}

+(UIColor*) faluRed {
    return calculateColor(128, 24, 24);
}

+(UIColor*) fernGreen {
    return calculateColor(79, 121, 66);
}

+(UIColor*) firebrick {
    return calculateColor(178, 34, 34);
}

+(UIColor*) flax {
    return calculateColor(238, 220, 130);
}

+(UIColor*) forestGreen {
    return calculateColor(34, 139, 34);
}

+(UIColor*) frenchRose {
    return calculateColor(246, 74, 138);
}

+(UIColor*) fuchsia {
    return calculateColor(255, 0, 255);
}

+(UIColor*) fuchsiaPink {
    return calculateColor(255, 119, 255);
}

+(UIColor*) gamboge {
    return calculateColor(228, 155, 15);
}

+(UIColor*) metallicGold {
    return calculateColor(212, 175, 55);
}

+(UIColor*) goldWeb {
    return calculateColor(255, 215, 0);
}

+(UIColor*) goldenBrown {
    return calculateColor(153, 101, 21);
}

+(UIColor*) goldenYellow {
    return calculateColor(255, 223, 0);
}

+(UIColor*) goldenrod {
    return calculateColor(218, 165, 32);
}

+(UIColor*) greyAsparagus {
    return calculateColor(70, 89, 69);
}

+(UIColor*) green {
    return calculateColor(0, 255, 0);
}

+(UIColor*) greenWeb {
    return calculateColor(0, 128, 0);
}

+(UIColor*) pigmentGreen {
    return calculateColor(0, 165, 80);
}

+(UIColor*) rybGreen {
    return calculateColor(102, 176, 50);
}

+(UIColor*) greenYellow {
    return calculateColor(173, 255, 47);
}

+(UIColor*) grey {
    return calculateColor(128, 128, 128);
}

+(UIColor*) hanPurple {
    return calculateColor(82, 24, 250);
}

+(UIColor*) harlequin {
    return calculateColor(63, 255, 0);
}

+(UIColor*) heliotrope {
    return calculateColor(223, 115, 255);
}

+(UIColor*) hollywoodCerise {
    return calculateColor(244, 0, 161);
}

+(UIColor*) hotMagenta {
    return calculateColor(255, 0, 204);
}

+(UIColor*) hotPink {
    return calculateColor(255, 105, 180);
}

+(UIColor*) indigo {
    return calculateColor(0, 65, 106);
}

+(UIColor*) indigoWeb {
    return calculateColor(75, 0, 130);
}

+(UIColor*) internationalKleinBlue {
    return calculateColor(0, 47, 167);
}

+(UIColor*) internationalOrange {
    return calculateColor(255, 79, 0);
}

+(UIColor*) islamicGreen {
    return calculateColor(0, 153, 0);
}

+(UIColor*) ivory {
    return calculateColor(255, 255, 240);
}

+(UIColor*) jade {
    return calculateColor(0, 168, 107);
}

+(UIColor*) kellyGreen {
    return calculateColor(76, 187, 23);
}

+(UIColor*) khaki {
    return calculateColor(195, 176, 145);
}

+(UIColor*) lightKhaki {
    return calculateColor(240, 230, 140);
}

+(UIColor*) lavender {
    return calculateColor(181, 126, 220);
}

+(UIColor*) lavenderWeb {
    return calculateColor(230, 230, 250);
}

+(UIColor*) lavenderBlue {
    return calculateColor(204, 204, 255);
}

+(UIColor*) lavenderBlush {
    return calculateColor(255, 240, 245);
}

+(UIColor*) lavenderGrey {
    return calculateColor(196, 195, 221);
}

+(UIColor*) lavenderMagenta {
    return calculateColor(238, 130, 238);
}

+(UIColor*) lavenderPink {
    return calculateColor(251, 174, 210);
}

+(UIColor*) lavenderPurple {
    return calculateColor(150, 120, 182);
}

+(UIColor*) lavenderRose {
    return calculateColor(251, 160, 227);
}

+(UIColor*) lawnGreen {
    return calculateColor(124, 252, 0);
}

+(UIColor*) lemon {
    return calculateColor(253, 233, 16);
}

+(UIColor*) lemonChiffon {
    return calculateColor(255, 250, 205);
}

+(UIColor*) lightBlue {
    return calculateColor(173, 216, 230);
}

+(UIColor*) lightPink {
    return calculateColor(255, 182, 193);
}

+(UIColor*) lilac {
    return calculateColor(200, 162, 200);
}

+(UIColor*) lime {
    return calculateColor(191, 255, 0);
}

+(UIColor*) limeWeb {
    return calculateColor(0, 255, 0);
}

+(UIColor*) limeGreen {
    return calculateColor(50, 205, 50);
}

+(UIColor*) linen {
    return calculateColor(250, 240, 230);
}

+(UIColor*) magenta {
    return calculateColor(255, 0, 255);
}

+(UIColor*) magentaDye {
    return calculateColor(202, 31, 23);
}

+(UIColor*) processMagenta {
    return calculateColor(255, 0, 144);
}

+(UIColor*) magicMint {
    return calculateColor(170, 240, 209);
}

+(UIColor*) magnolia {
    return calculateColor(248, 244, 255);
}

+(UIColor*) malachite {
    return calculateColor(11, 218, 81);
}

+(UIColor*) maroonWeb {
    return calculateColor(128, 0, 0);
}

+(UIColor*) maroon {
    return calculateColor(176, 48, 96);
}

+(UIColor*) mayaBlue {
    return calculateColor(115, 194, 251);
}

+(UIColor*) mauve {
    return calculateColor(224, 176, 255);
}

+(UIColor*) mauveTaupe {
    return calculateColor(145, 95, 109);
}

+(UIColor*) mediumBlue {
    return calculateColor(0, 0, 205);
}

+(UIColor*) mediumCarmine {
    return calculateColor(175, 64, 53);
}

+(UIColor*) mediumLavenderMagenta {
    return calculateColor(204, 153, 204);
}

+(UIColor*) mediumPurple {
    return calculateColor(147, 112, 219);
}

+(UIColor*) mediumSpringGreen {
    return calculateColor(0, 250, 154);
}

+(UIColor*) midnightBlue {
    return calculateColor(0, 51, 102);
}

+(UIColor*) mintGreen {
    return calculateColor(152, 255, 152);
}

+(UIColor*) mistyRose {
    return calculateColor(255, 228, 225);
}

+(UIColor*) mossGreen {
    return calculateColor(173, 223, 173);
}

+(UIColor*) mountbattenPink {
    return calculateColor(153, 122, 141);
}

+(UIColor*) mustard {
    return calculateColor(255, 219, 88);
}

+(UIColor*) myrtle {
    return calculateColor(33, 66, 30);
}

+(UIColor*) navajoWhite {
    return calculateColor(255, 222, 173);
}

+(UIColor*) navyBlue {
    return calculateColor(0, 0, 128);
}

+(UIColor*) notEditable {
    return calculateColor(81, 102, 145);
}

+(UIColor*) ochre {
    return calculateColor(204, 119, 34);
}

+(UIColor*) officeGreen {
    return calculateColor(0, 128, 0);
}

+(UIColor*) oldGold {
    return calculateColor(207, 181, 59);
}

+(UIColor*) oldLace {
    return calculateColor(253, 245, 230);
}

+(UIColor*) oldLavender {
    return calculateColor(121, 104, 120);
}

+(UIColor*) oldRose {
    return calculateColor(192, 46, 76);
}

+(UIColor*) olive {
    return calculateColor(128, 128, 0);
}

+(UIColor*) oliveDrab {
    return calculateColor(107, 142, 35);
}

+(UIColor*) olivine {
    return calculateColor(154, 185, 115);
}

+(UIColor*) orange {
    return calculateColor(255, 127, 0);
}

+(UIColor*) rybOrange {
    return calculateColor(251, 153, 2);
}

+(UIColor*) orangeWeb {
    return calculateColor(255, 165, 0);
}

+(UIColor*) orangePeel {
    return calculateColor(255, 160, 0);
}

+(UIColor*) orangeRed {
    return calculateColor(255, 69, 0);
}

+(UIColor*) orchid {
    return calculateColor(218, 112, 214);
}

+(UIColor*) paleBlue {
    return calculateColor(175, 238, 238);
}

+(UIColor*) paleBrown {
    return calculateColor(152, 118, 84);
}

+(UIColor*) paleCarmine {
    return calculateColor(175, 64, 53);
}

+(UIColor*) paleChestnut {
    return calculateColor(221, 173, 175);
}

+(UIColor*) paleCornflowerBlue {
    return calculateColor(171, 205, 239);
}

+(UIColor*) paleMagenta {
    return calculateColor(249, 132, 229);
}

+(UIColor*) palePink {
    return calculateColor(250, 218, 221);
}

+(UIColor*) paleRedViolet {
    return calculateColor(219, 112, 147);
}

+(UIColor*) papayaWhip {
    return calculateColor(255, 239, 213);
}

+(UIColor*) pastelGreen {
    return calculateColor(119, 221, 119);
}

+(UIColor*) pastelPink {
    return calculateColor(255, 209, 220);
}

+(UIColor*) peach {
    return calculateColor(255, 229, 180);
}

+(UIColor*) peachOrange {
    return calculateColor(255, 204, 153);
}

+(UIColor*) peachYellow {
    return calculateColor(250, 223, 173);
}

+(UIColor*) pear {
    return calculateColor(209, 226, 49);
}

+(UIColor*) periwinkle {
    return calculateColor(204, 204, 255);
}

+(UIColor*) persianBlue {
    return calculateColor(28, 57, 187);
}

+(UIColor*) persianGreen {
    return calculateColor(0, 166, 147);
}

+(UIColor*) persianIndigo {
    return calculateColor(50, 18, 122);
}

+(UIColor*) persianOrange {
    return calculateColor(217, 144, 88);
}

+(UIColor*) persianRed {
    return calculateColor(204, 51, 51);
}

+(UIColor*) persianPink {
    return calculateColor(247, 127, 190);
}

+(UIColor*) persianRose {
    return calculateColor(254, 40, 162);
}

+(UIColor*) persimmon {
    return calculateColor(236, 88, 0);
}

+(UIColor*) pineGreen {
    return calculateColor(1, 121, 111);
}

+(UIColor*) pink {
    return calculateColor(255, 192, 203);
}

+(UIColor*) pinkOrange {
    return calculateColor(255, 153, 102);
}

+(UIColor*) platinum {
    return calculateColor(229, 228, 226);
}

+(UIColor*) plum {
    return calculateColor(204, 153, 204);
}

+(UIColor*) powderBlue {
    return calculateColor(176, 224, 230);
}

+(UIColor*) puce {
    return calculateColor(204, 136, 153);
}

+(UIColor*) prussianBlue {
    return calculateColor(0, 49, 83);
}

+(UIColor*) psychedelicPurple {
    return calculateColor(221, 0, 255);
}

+(UIColor*) pumpkin {
    return calculateColor(255, 117, 24);
}

+(UIColor*) purpleWeb {
    return calculateColor(128, 0, 128);
}

+(UIColor*) purple {
    return calculateColor(160, 92, 240);
}

+(UIColor*) purpleTaupe {
    return calculateColor(80, 64, 77);
}

+(UIColor*) rawUmber {
    return calculateColor(115, 74, 18);
}

+(UIColor*) razzmatazz {
    return calculateColor(227, 11, 92);
}

+(UIColor*) red {
    return calculateColor(255, 0, 0);
}

+(UIColor*) pigmentRed {
    return calculateColor(237, 28, 36);
}

+(UIColor*) rybRed {
    return calculateColor(254, 39, 18);
}

+(UIColor*) redBiolet {
    return calculateColor(199, 21, 133);
}

+(UIColor*) richCarmine {
    return calculateColor(215, 0, 64);
}

+(UIColor*) robinEggBlue {
    return calculateColor(0, 204, 204);
}

+(UIColor*) rose {
    return calculateColor(255, 0, 127);
}

+(UIColor*) roseMadder {
    return calculateColor(227, 38, 54);
}

+(UIColor*) roseTaupe {
    return calculateColor(144, 93, 93);
}

+(UIColor*) royalBlue {
    return calculateColor(65, 105, 225);
}

+(UIColor*) royalPurple {
    return calculateColor(107, 63, 160);
}

+(UIColor*) ruby {
    return calculateColor(224, 17, 95);
}

+(UIColor*) russet {
    return calculateColor(128, 70, 27);
}

+(UIColor*) rust {
    return calculateColor(183, 65, 14);
}

+(UIColor*) safetyOrange {
    return calculateColor(255, 102, 0);
}

+(UIColor*) blazeOrange {
    return calculateColor(255, 102, 0);
}

+(UIColor*) saffron {
    return calculateColor(244, 196, 48);
}

+(UIColor*) salmon {
    return calculateColor(255, 140, 105);
}

+(UIColor*) sandyBrown {
    return calculateColor(244, 164, 96);
}

+(UIColor*) sangria {
    return calculateColor(146, 0, 10);
}

+(UIColor*) sapphire {
    return calculateColor(8, 37, 103);
}

+(UIColor*) scarlet {
    return calculateColor(255, 36, 0);
}

+(UIColor*) schoolBusYellow {
    return calculateColor(255, 216, 0);
}

+(UIColor*) seaGreen {
    return calculateColor(46, 139, 87);
}

+(UIColor*) seashell {
    return calculateColor(255, 245, 238);
}

+(UIColor*) selectiveYellow {
    return calculateColor(255, 186, 0);
}

+(UIColor*) sepia {
    return calculateColor(112, 66, 20);
}

+(UIColor*) shamrockGreen {
    return calculateColor(0, 158, 96);
}

+(UIColor*) shockingPink {
    return calculateColor(252, 15, 192);
}

+(UIColor*) silver {
    return calculateColor(192, 192, 192);
}

+(UIColor*) skyBlue {
    return calculateColor(135, 206, 235);
}

+(UIColor*) slateGrey {
    return calculateColor(112, 128, 144);
}

+(UIColor*) smalt {
    return calculateColor(0, 51, 153);
}

+(UIColor*) springBud {
    return calculateColor(167, 252, 0);
}

+(UIColor*) springGreen {
    return calculateColor(0, 255, 127);
}

+(UIColor*) steelBlue {
    return calculateColor(70, 130, 180);
}

+(UIColor*) tan {
    return calculateColor(210, 180, 140);
}

+(UIColor*) tangerine {
    return calculateColor(242, 133, 0);
}

+(UIColor*) tangerineYellow {
    return calculateColor(255, 204, 0);
}

+(UIColor*) taupe {
    return calculateColor(72, 60, 50);
}

+(UIColor*) teaGreen {
    return calculateColor(208, 240, 192);
}

+(UIColor*) teaRoseOrange {
    return calculateColor(248, 131, 194);
}

+(UIColor*) teaRose {
    return calculateColor(244, 194, 194);
}

+(UIColor*) teal {
    return calculateColor(0, 128, 128);
}

+(UIColor*) tawny {
    return calculateColor(205, 87, 0);
}

+(UIColor*) terraCotta {
    return calculateColor(226, 114, 91);
}

+(UIColor*) thistle {
    return calculateColor(216, 191, 216);
}

+(UIColor*) tomato {
    return calculateColor(255, 99, 71);
}

+(UIColor*) transparentGray {
    return calculateColorWithAlpha(60, 60, 60, .8);
}

+(UIColor*) transparentLightGray {
    return calculateColorWithAlpha(200, 200, 200, .6);
}

+(UIColor*) turquoise {
    return calculateColor(48, 213, 200);
}

+(UIColor*) tyrianPurple {
    return calculateColor(102, 2, 60);
}

+(UIColor*) ultramarine {
    return calculateColor(18, 10, 143);
}

+(UIColor*) unitedNationsBlue {
    return calculateColor(91, 146, 229);
}

+(UIColor*) vegasGold {
    return calculateColor(197, 179, 88);
}

+(UIColor*) vermilion {
    return calculateColor(227, 66, 51);
}

+(UIColor*) violet {
    return calculateColor(139, 0, 255);
}

+(UIColor*) violetWeb {
    return calculateColor(238, 130, 238);
}

+(UIColor*) rybViolet {
    return calculateColor(2, 71, 54);
}

+(UIColor*) viridian {
    return calculateColor(64, 130, 109);
}

+(UIColor*) wheat {
    return calculateColor(245, 222, 179);
}

+(UIColor*) white {
    return calculateColor(255, 255, 255);
}

+(UIColor*) wisteria {
    return calculateColor(201, 160, 220);
}

+(UIColor*) yellow {
    return calculateColor(255, 255, 0);
}

+(UIColor*) processYellow {
    return calculateColor(255, 239, 0);
}

+(UIColor*) rybYellow {
    return calculateColor(254, 254, 51);
}

+(UIColor*) yellowGreen {
    return calculateColor(154, 205, 50);
}

+(UIColor*) zinnwaldite {
    return calculateColor(235, 194, 175);
}

@end
