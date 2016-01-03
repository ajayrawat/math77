      DOUBLE PRECISION FUNCTION DEI (XIN)
c Copyright (c) 1996 California Institute of Technology, Pasadena, CA.
c ALL RIGHTS RESERVED.
c Based on Government Sponsored Research NAS7-03001.
c>> 1996-04-27 DEI Krogh  Changes to use .C. and C%%.
c>> 1996-03-30 DEI Krogh  Added external statements.
C>> 1995-11-28 DEI Krogh  GO TO's => blodk IF's, removed multiple entry.
C>> 1995-11-14 DEI Krogh  Changes to simplify conversion to C.
C>> 1995-11-03 DEI Krogh  Removed blanks in numbers for C conversion.
C>> 1994-10-20 DEI Krogh  Changes to use M77CON
C>> 1994-04-20 DEI CLL  Edited type stmts to make DP & SP files similar.
C>> 1992-03-13 DEI FTK  Removed implicit statements.
C>> 1991-01-14 CLL DE1 Changed to generic name ABS
C>> 1990-11-29 CLL
C>> 1985-08-02 DEI    Lawson  Initial code.
C
C     JULY 1977 EDITION. W. FULLERTON, C3,
C     LOS ALAMOS SCIENTIFIC LAB.
C
C     REORGANIZATION OF FULLERTON'S DEI & DE1,
C     C.L. LAWSON & S.CHAN, JUNE 1983, JPL.
C
C     ----------------------------------------------------------------
C     MACHINE DEPENDENT VALUES ARE SET ON THE FIRST ENTRY
C     TO THIS CODE. EXAMPLES OF THESE VALUES FOLLOW:
C
C     SYSTEM         NTAE10   NTAE11   NTAE12   NTAE13   NTAE14
C     ------         ------   ------   ------   ------   ------
C     UNIVAC S.P.      **       16       14       13       12
C     UNIVAC D.P.      21       34       24       29       32
C
C     SYSTEM         NTE11    NTE12    XMAX     XMIN     DELTA
C     ------         -----    -----    ----     ----     -----
C     UNIVAC S.P.     13       10      84.8    -92.41    4.48
C     UNIVAC D.P.     19       17     703.2    -714.9    6.56
C
C     SYSTEM         EARG1    EARG2
C     ------         -----    -----
C     UNIVAC S.P.    89.42    88.03
C     UNIVAC D.P.    710.5    709.1
C
C     ----------------------------------------------------------------
c--D replaces "?": ?E1, ?EI, ?INITS, ?CSEVL, ?ERM1, ?ERV1
c     Also uses ERMSG
c     ------------------------------------------------------------------
      EXTERNAL DE1
      DOUBLE PRECISION XIN
      DOUBLE PRECISION DE1
c
      DEI = -DE1(-XIN)
      return
      end
c
      DOUBLE PRECISION FUNCTION DE1 (XIN)
      EXTERNAL D1MACH, DCSEVL
      INTEGER NTAE10,NTAE11,NTAE12,NTAE13,NTAE14,NTE11,NTE12
      DOUBLE PRECISION D1MACH,DCSEVL
      DOUBLE PRECISION AE10CS(50),AE11CS(60),AE12CS(41),AE13CS(50)
      DOUBLE PRECISION AE14CS(64),BIGNUM,DELTA
      DOUBLE PRECISION E11CS(29),E12CS(25),EARG1,EARG2
      DOUBLE PRECISION ETA,FAC,X,XIN,XMAX,XMIN,ZERO
C
      CHARACTER * 33 MSG1
      CHARACTER * 38 MSG2
      CHARACTER * 34 MSG3
      CHARACTER * 10 NAME
C
      SAVE DELTA,EARG1,EARG2,NTAE11,NTAE12,NTE11,NTE12,
     *     NTAE13,NTAE14,XMAX,XMIN,NTAE10
C
      DATA NTAE10, NTAE11, NTAE12, NTE11, NTE12, NTAE13, NTAE14 / 7*0 /
      DATA XMAX,ZERO / 2*0.D0 /
      DATA FAC / 0.999D0 /
C
      DATA MSG1 / '|X| SO LARGE DE1 or DEI OVERFLOWS' /
C
      DATA MSG2 / 'X = ZERO, DE1(0) or DEI(0) not defined' /
C
      DATA MSG3 / '|X| SO LARGE DE1 or DEI UNDERFLOWS' /
C
      DATA NAME / 'DE1 or DEI' /
C
C SERIES FOR AE10       ON THE INTERVAL -3.12500D-02 TO  0.
C                                        WITH WEIGHTED ERROR   4.62D-32
C                                         LOG WEIGHTED ERROR  31.34
C                               SIGNIFICANT FIGURES REQUIRED  29.70
C                                    DECIMAL PLACES REQUIRED  32.18
C
c++ Save data by elements if ~.C.
      DATA AE10CS(  1) / +.3284394579616699087873844201881D-1      /
      DATA AE10CS(  2) / -.1669920452031362851476184343387D-1      /
      DATA AE10CS(  3) / +.2845284724361346807424899853252D-3      /
      DATA AE10CS(  4) / -.7563944358516206489487866938533D-5      /
      DATA AE10CS(  5) / +.2798971289450859157504843180879D-6      /
      DATA AE10CS(  6) / -.1357901828534531069525563926255D-7      /
      DATA AE10CS(  7) / +.8343596202040469255856102904906D-9      /
      DATA AE10CS(  8) / -.6370971727640248438275242988532D-10     /
      DATA AE10CS(  9) / +.6007247608811861235760831561584D-11     /
      DATA AE10CS( 10) / -.7022876174679773590750626150088D-12     /
      DATA AE10CS( 11) / +.1018302673703687693096652346883D-12     /
      DATA AE10CS( 12) / -.1761812903430880040406309966422D-13     /
      DATA AE10CS( 13) / +.3250828614235360694244030353877D-14     /
      DATA AE10CS( 14) / -.5071770025505818678824872259044D-15     /
      DATA AE10CS( 15) / +.1665177387043294298172486084156D-16     /
      DATA AE10CS( 16) / +.3166753890797514400677003536555D-16     /
      DATA AE10CS( 17) / -.1588403763664141515133118343538D-16     /
      DATA AE10CS( 18) / +.4175513256138018833003034618484D-17     /
      DATA AE10CS( 19) / -.2892347749707141906710714478852D-18     /
      DATA AE10CS( 20) / -.2800625903396608103506340589669D-18     /
      DATA AE10CS( 21) / +.1322938639539270903707580023781D-18     /
      DATA AE10CS( 22) / -.1804447444177301627283887833557D-19     /
      DATA AE10CS( 23) / -.7905384086522616076291644817604D-20     /
      DATA AE10CS( 24) / +.4435711366369570103946235838027D-20     /
      DATA AE10CS( 25) / -.4264103994978120868865309206555D-21     /
      DATA AE10CS( 26) / -.3920101766937117541553713162048D-21     /
      DATA AE10CS( 27) / +.1527378051343994266343752326971D-21     /
      DATA AE10CS( 28) / +.1024849527049372339310308783117D-22     /
      DATA AE10CS( 29) / -.2134907874771433576262711405882D-22     /
      DATA AE10CS( 30) / +.3239139475160028267061694700366D-23     /
      DATA AE10CS( 31) / +.2142183762299889954762643168296D-23     /
      DATA AE10CS( 32) / -.8234609419601018414700348082312D-24     /
      DATA AE10CS( 33) / -.1524652829645809479613694401140D-24     /
      DATA AE10CS( 34) / +.1378208282460639134668480364325D-24     /
      DATA AE10CS( 35) / +.2131311202833947879523224999253D-26     /
      DATA AE10CS( 36) / -.2012649651526484121817466763127D-25     /
      DATA AE10CS( 37) / +.1995535662263358016106311782673D-26     /
      DATA AE10CS( 38) / +.2798995808984003464948686520319D-26     /
      DATA AE10CS( 39) / -.5534511845389626637640819277823D-27     /
      DATA AE10CS( 40) / -.3884995396159968861682544026146D-27     /
      DATA AE10CS( 41) / +.1121304434507359382850680354679D-27     /
      DATA AE10CS( 42) / +.5566568152423740948256563833514D-28     /
      DATA AE10CS( 43) / -.2045482929810499700448533938176D-28     /
      DATA AE10CS( 44) / -.8453813992712336233411457493674D-29     /
      DATA AE10CS( 45) / +.3565758433431291562816111116287D-29     /
      DATA AE10CS( 46) / +.1383653872125634705539949098871D-29     /
      DATA AE10CS( 47) / -.6062167864451372436584533764778D-30     /
      DATA AE10CS( 48) / -.2447198043989313267437655119189D-30     /
      DATA AE10CS( 49) / +.1006850640933998348011548180480D-30     /
      DATA AE10CS( 50) / +.4623685555014869015664341461674D-31     /
C
C SERIES FOR AE11       ON THE INTERVAL -1.25000D-01 TO -3.12500D-02
C                                        WITH WEIGHTED ERROR   2.22D-32
C                                         LOG WEIGHTED ERROR  31.65
C                               SIGNIFICANT FIGURES REQUIRED  30.75
C                                    DECIMAL PLACES REQUIRED  32.54
C
c++ Save data by elements if ~.C.
      DATA AE11CS(  1) / +.20263150647078889499401236517381D+0     /
      DATA AE11CS(  2) / -.73655140991203130439536898728034D-1     /
      DATA AE11CS(  3) / +.63909349118361915862753283840020D-2     /
      DATA AE11CS(  4) / -.60797252705247911780653153363999D-3     /
      DATA AE11CS(  5) / -.73706498620176629330681411493484D-4     /
      DATA AE11CS(  6) / +.48732857449450183453464992488076D-4     /
      DATA AE11CS(  7) / -.23837064840448290766588489460235D-5     /
      DATA AE11CS(  8) / -.30518612628561521027027332246121D-5     /
      DATA AE11CS(  9) / +.17050331572564559009688032992907D-6     /
      DATA AE11CS( 10) / +.23834204527487747258601598136403D-6     /
      DATA AE11CS( 11) / +.10781772556163166562596872364020D-7     /
      DATA AE11CS( 12) / -.17955692847399102653642691446599D-7     /
      DATA AE11CS( 13) / -.41284072341950457727912394640436D-8     /
      DATA AE11CS( 14) / +.68622148588631968618346844526664D-9     /
      DATA AE11CS( 15) / +.53130183120506356147602009675961D-9     /
      DATA AE11CS( 16) / +.78796880261490694831305022893515D-10    /
      DATA AE11CS( 17) / -.26261762329356522290341675271232D-10    /
      DATA AE11CS( 18) / -.15483687636308261963125756294100D-10    /
      DATA AE11CS( 19) / -.25818962377261390492802405122591D-11    /
      DATA AE11CS( 20) / +.59542879191591072658903529959352D-12    /
      DATA AE11CS( 21) / +.46451400387681525833784919321405D-12    /
      DATA AE11CS( 22) / +.11557855023255861496288006203731D-12    /
      DATA AE11CS( 23) / -.10475236870835799012317547189670D-14    /
      DATA AE11CS( 24) / -.11896653502709004368104489260929D-13    /
      DATA AE11CS( 25) / -.47749077490261778752643019349950D-14    /
      DATA AE11CS( 26) / -.81077649615772777976249734754135D-15    /
      DATA AE11CS( 27) / +.13435569250031554199376987998178D-15    /
      DATA AE11CS( 28) / +.14134530022913106260248873881287D-15    /
      DATA AE11CS( 29) / +.49451592573953173115520663232883D-16    /
      DATA AE11CS( 30) / +.79884048480080665648858587399367D-17    /
      DATA AE11CS( 31) / -.14008632188089809829248711935393D-17    /
      DATA AE11CS( 32) / -.14814246958417372107722804001680D-17    /
      DATA AE11CS( 33) / -.55826173646025601904010693937113D-18    /
      DATA AE11CS( 34) / -.11442074542191647264783072544598D-18    /
      DATA AE11CS( 35) / +.25371823879566853500524018479923D-20    /
      DATA AE11CS( 36) / +.13205328154805359813278863389097D-19    /
      DATA AE11CS( 37) / +.62930261081586809166287426789485D-20    /
      DATA AE11CS( 38) / +.17688270424882713734999261332548D-20    /
      DATA AE11CS( 39) / +.23266187985146045209674296887432D-21    /
      DATA AE11CS( 40) / -.67803060811125233043773831844113D-22    /
      DATA AE11CS( 41) / -.59440876959676373802874150531891D-22    /
      DATA AE11CS( 42) / -.23618214531184415968532592503466D-22    /
      DATA AE11CS( 43) / -.60214499724601478214168478744576D-23    /
      DATA AE11CS( 44) / -.65517906474348299071370444144639D-24    /
      DATA AE11CS( 45) / +.29388755297497724587042038699349D-24    /
      DATA AE11CS( 46) / +.22601606200642115173215728758510D-24    /
      DATA AE11CS( 47) / +.89534369245958628745091206873087D-25    /
      DATA AE11CS( 48) / +.24015923471098457555772067457706D-25    /
      DATA AE11CS( 49) / +.34118376888907172955666423043413D-26    /
      DATA AE11CS( 50) / -.71617071694630342052355013345279D-27    /
      DATA AE11CS( 51) / -.75620390659281725157928651980799D-27    /
      DATA AE11CS( 52) / -.33774612157467324637952920780800D-27    /
      DATA AE11CS( 53) / -.10479325703300941711526430332245D-27    /
      DATA AE11CS( 54) / -.21654550252170342240854880201386D-28    /
      DATA AE11CS( 55) / -.75297125745288269994689298432000D-30    /
      DATA AE11CS( 56) / +.19103179392798935768638084000426D-29    /
      DATA AE11CS( 57) / +.11492104966530338547790728833706D-29    /
      DATA AE11CS( 58) / +.43896970582661751514410359193600D-30    /
      DATA AE11CS( 59) / +.12320883239205686471647157725866D-30    /
      DATA AE11CS( 60) / +.22220174457553175317538581162666D-31    /
C
C SERIES FOR AE12       ON THE INTERVAL -2.50000D-01 TO -1.25000D-01
C                                        WITH WEIGHTED ERROR   5.19D-32
C                                         LOG WEIGHTED ERROR  31.28
C                               SIGNIFICANT FIGURES REQUIRED  30.82
C                                    DECIMAL PLACES REQUIRED  32.09
C
c++ Save data by elements if ~.C.
      DATA AE12CS(  1) / +.63629589796747038767129887806803D+0     /
      DATA AE12CS(  2) / -.13081168675067634385812671121135D+0     /
      DATA AE12CS(  3) / -.84367410213053930014487662129752D-2     /
      DATA AE12CS(  4) / +.26568491531006685413029428068906D-2     /
      DATA AE12CS(  5) / +.32822721781658133778792170142517D-3     /
      DATA AE12CS(  6) / -.23783447771430248269579807851050D-4     /
      DATA AE12CS(  7) / -.11439804308100055514447076797047D-4     /
      DATA AE12CS(  8) / -.14405943433238338455239717699323D-5     /
      DATA AE12CS(  9) / +.52415956651148829963772818061664D-8     /
      DATA AE12CS( 10) / +.38407306407844323480979203059716D-7     /
      DATA AE12CS( 11) / +.85880244860267195879660515759344D-8     /
      DATA AE12CS( 12) / +.10219226625855003286339969553911D-8     /
      DATA AE12CS( 13) / +.21749132323289724542821339805992D-10    /
      DATA AE12CS( 14) / -.22090238142623144809523503811741D-10    /
      DATA AE12CS( 15) / -.63457533544928753294383622208801D-11    /
      DATA AE12CS( 16) / -.10837746566857661115340539732919D-11    /
      DATA AE12CS( 17) / -.11909822872222586730262200440277D-12    /
      DATA AE12CS( 18) / -.28438682389265590299508766008661D-14    /
      DATA AE12CS( 19) / +.25080327026686769668587195487546D-14    /
      DATA AE12CS( 20) / +.78729641528559842431597726421265D-15    /
      DATA AE12CS( 21) / +.15475066347785217148484334637329D-15    /
      DATA AE12CS( 22) / +.22575322831665075055272608197290D-16    /
      DATA AE12CS( 23) / +.22233352867266608760281380836693D-17    /
      DATA AE12CS( 24) / +.16967819563544153513464194662399D-19    /
      DATA AE12CS( 25) / -.57608316255947682105310087304533D-19    /
      DATA AE12CS( 26) / -.17591235774646878055625369408853D-19    /
      DATA AE12CS( 27) / -.36286056375103174394755328682666D-20    /
      DATA AE12CS( 28) / -.59235569797328991652558143488000D-21    /
      DATA AE12CS( 29) / -.76030380926310191114429136895999D-22    /
      DATA AE12CS( 30) / -.62547843521711763842641428479999D-23    /
      DATA AE12CS( 31) / +.25483360759307648606037606400000D-24    /
      DATA AE12CS( 32) / +.25598615731739857020168874666666D-24    /
      DATA AE12CS( 33) / +.71376239357899318800207052800000D-25    /
      DATA AE12CS( 34) / +.14703759939567568181578956800000D-25    /
      DATA AE12CS( 35) / +.25105524765386733555198634666666D-26    /
      DATA AE12CS( 36) / +.35886666387790890886583637333333D-27    /
      DATA AE12CS( 37) / +.39886035156771301763317759999999D-28    /
      DATA AE12CS( 38) / +.21763676947356220478805333333333D-29    /
      DATA AE12CS( 39) / -.46146998487618942367607466666666D-30    /
      DATA AE12CS( 40) / -.20713517877481987707153066666666D-30    /
      DATA AE12CS( 41) / -.51890378563534371596970666666666D-31    /
C
C SERIES FOR E11        ON THE INTERVAL -4.00000D+00 TO -1.00000D+00
C                                        WITH WEIGHTED ERROR   8.49D-34
C                                         LOG WEIGHTED ERROR  33.07
C                               SIGNIFICANT FIGURES REQUIRED  34.13
C                                    DECIMAL PLACES REQUIRED  33.80
C
c++ Save data by elements if ~.C.
      DATA E11CS(  1) / -.16113461655571494025720663927566180D+2  /
      DATA E11CS(  2) / +.77940727787426802769272245891741497D+1  /
      DATA E11CS(  3) / -.19554058188631419507127283812814491D+1  /
      DATA E11CS(  4) / +.37337293866277945611517190865690209D+0  /
      DATA E11CS(  5) / -.56925031910929019385263892220051166D-1  /
      DATA E11CS(  6) / +.72110777696600918537847724812635813D-2  /
      DATA E11CS(  7) / -.78104901449841593997715184089064148D-3  /
      DATA E11CS(  8) / +.73880933562621681878974881366177858D-4  /
      DATA E11CS(  9) / -.62028618758082045134358133607909712D-5  /
      DATA E11CS( 10) / +.46816002303176735524405823868362657D-6  /
      DATA E11CS( 11) / -.32092888533298649524072553027228719D-7  /
      DATA E11CS( 12) / +.20151997487404533394826262213019548D-8  /
      DATA E11CS( 13) / -.11673686816697793105356271695015419D-9  /
      DATA E11CS( 14) / +.62762706672039943397788748379615573D-11 /
      DATA E11CS( 15) / -.31481541672275441045246781802393600D-12 /
      DATA E11CS( 16) / +.14799041744493474210894472251733333D-13 /
      DATA E11CS( 17) / -.65457091583979673774263401588053333D-15 /
      DATA E11CS( 18) / +.27336872223137291142508012748799999D-16 /
      DATA E11CS( 19) / -.10813524349754406876721727624533333D-17 /
      DATA E11CS( 20) / +.40628328040434303295300348586666666D-19 /
      DATA E11CS( 21) / -.14535539358960455858914372266666666D-20 /
      DATA E11CS( 22) / +.49632746181648636830198442666666666D-22 /
      DATA E11CS( 23) / -.16208612696636044604866560000000000D-23 /
      DATA E11CS( 24) / +.50721448038607422226431999999999999D-25 /
      DATA E11CS( 25) / -.15235811133372207813973333333333333D-26 /
      DATA E11CS( 26) / +.44001511256103618696533333333333333D-28 /
      DATA E11CS( 27) / -.12236141945416231594666666666666666D-29 /
      DATA E11CS( 28) / +.32809216661066001066666666666666666D-31 /
      DATA E11CS( 29) / -.84933452268306432000000000000000000D-33 /
C
C SERIES FOR E12        ON THE INTERVAL -1.00000D+00 TO  1.00000D+00
C                                        WITH WEIGHTED ERROR   8.08D-33
C                                         LOG WEIGHTED ERROR  32.09
C                        APPROX SIGNIFICANT FIGURES REQUIRED  30.4
C                                    DECIMAL PLACES REQUIRED  32.79
C
c++ Save data by elements if ~.C.
      DATA E12CS(  1) / -.3739021479220279511668698204827D-1      /
      DATA E12CS(  2) / +.4272398606220957726049179176528D-1      /
      DATA E12CS(  3) / -.130318207984970054415392055219726D+0    /
      DATA E12CS(  4) / +.144191240246988907341095893982137D-1    /
      DATA E12CS(  5) / -.134617078051068022116121527983553D-2    /
      DATA E12CS(  6) / +.107310292530637799976115850970073D-3    /
      DATA E12CS(  7) / -.742999951611943649610283062223163D-5    /
      DATA E12CS(  8) / +.453773256907537139386383211511827D-6    /
      DATA E12CS(  9) / -.247641721139060131846547423802912D-7    /
      DATA E12CS( 10) / +.122076581374590953700228167846102D-8    /
      DATA E12CS( 11) / -.548514148064092393821357398028261D-10   /
      DATA E12CS( 12) / +.226362142130078799293688162377002D-11   /
      DATA E12CS( 13) / -.863589727169800979404172916282240D-13   /
      DATA E12CS( 14) / +.306291553669332997581032894881279D-14   /
      DATA E12CS( 15) / -.101485718855944147557128906734933D-15   /
      DATA E12CS( 16) / +.315482174034069877546855328426666D-17   /
      DATA E12CS( 17) / -.923604240769240954484015923200000D-19   /
      DATA E12CS( 18) / +.255504267970814002440435029333333D-20   /
      DATA E12CS( 19) / -.669912805684566847217882453333333D-22   /
      DATA E12CS( 20) / +.166925405435387319431987199999999D-23   /
      DATA E12CS( 21) / -.396254925184379641856000000000000D-25   /
      DATA E12CS( 22) / +.898135896598511332010666666666666D-27   /
      DATA E12CS( 23) / -.194763366993016433322666666666666D-28   /
      DATA E12CS( 24) / +.404836019024630033066666666666666D-30   /
      DATA E12CS( 25) / -.807981567699845120000000000000000D-32   /
C
C SERIES FOR AE13       ON THE INTERVAL  2.50000D-01 TO  1.00000D+00
C                                        WITH WEIGHTED ERROR   6.65D-32
C                                         LOG WEIGHTED ERROR  31.18
C                               SIGNIFICANT FIGURES REQUIRED  30.69
C                                    DECIMAL PLACES REQUIRED  32.03
C
c++ Save data by elements if ~.C.
      DATA AE13CS(  1) / -.60577324664060345999319382737747D+0     /
      DATA AE13CS(  2) / -.11253524348366090030649768852718D+0     /
      DATA AE13CS(  3) / +.13432266247902779492487859329414D-1     /
      DATA AE13CS(  4) / -.19268451873811457249246838991303D-2     /
      DATA AE13CS(  5) / +.30911833772060318335586737475368D-3     /
      DATA AE13CS(  6) / -.53564132129618418776393559795147D-4     /
      DATA AE13CS(  7) / +.98278128802474923952491882717237D-5     /
      DATA AE13CS(  8) / -.18853689849165182826902891938910D-5     /
      DATA AE13CS(  9) / +.37494319356894735406964042190531D-6     /
      DATA AE13CS( 10) / -.76823455870552639273733465680556D-7     /
      DATA AE13CS( 11) / +.16143270567198777552956300060868D-7     /
      DATA AE13CS( 12) / -.34668022114907354566309060226027D-8     /
      DATA AE13CS( 13) / +.75875420919036277572889747054114D-9     /
      DATA AE13CS( 14) / -.16886433329881412573514526636703D-9     /
      DATA AE13CS( 15) / +.38145706749552265682804250927272D-10    /
      DATA AE13CS( 16) / -.87330266324446292706851718272334D-11    /
      DATA AE13CS( 17) / +.20236728645867960961794311064330D-11    /
      DATA AE13CS( 18) / -.47413283039555834655210340820160D-12    /
      DATA AE13CS( 19) / +.11221172048389864324731799928920D-12    /
      DATA AE13CS( 20) / -.26804225434840309912826809093395D-13    /
      DATA AE13CS( 21) / +.64578514417716530343580369067212D-14    /
      DATA AE13CS( 22) / -.15682760501666478830305702849194D-14    /
      DATA AE13CS( 23) / +.38367865399315404861821516441408D-15    /
      DATA AE13CS( 24) / -.94517173027579130478871048932556D-16    /
      DATA AE13CS( 25) / +.23434812288949573293896666439133D-16    /
      DATA AE13CS( 26) / -.58458661580214714576123194419882D-17    /
      DATA AE13CS( 27) / +.14666229867947778605873617419195D-17    /
      DATA AE13CS( 28) / -.36993923476444472706592538274474D-18    /
      DATA AE13CS( 29) / +.93790159936721242136014291817813D-19    /
      DATA AE13CS( 30) / -.23893673221937873136308224087381D-19    /
      DATA AE13CS( 31) / +.61150624629497608051934223837866D-20    /
      DATA AE13CS( 32) / -.15718585327554025507719853288106D-20    /
      DATA AE13CS( 33) / +.40572387285585397769519294491306D-21    /
      DATA AE13CS( 34) / -.10514026554738034990566367122773D-21    /
      DATA AE13CS( 35) / +.27349664930638667785806003131733D-22    /
      DATA AE13CS( 36) / -.71401604080205796099355574271999D-23    /
      DATA AE13CS( 37) / +.18705552432235079986756924211199D-23    /
      DATA AE13CS( 38) / -.49167468166870480520478020949333D-24    /
      DATA AE13CS( 39) / +.12964988119684031730916087125333D-24    /
      DATA AE13CS( 40) / -.34292515688362864461623940437333D-25    /
      DATA AE13CS( 41) / +.90972241643887034329104820906666D-26    /
      DATA AE13CS( 42) / -.24202112314316856489934847999999D-26    /
      DATA AE13CS( 43) / +.64563612934639510757670475093333D-27    /
      DATA AE13CS( 44) / -.17269132735340541122315987626666D-27    /
      DATA AE13CS( 45) / +.46308611659151500715194231466666D-28    /
      DATA AE13CS( 46) / -.12448703637214131241755170133333D-28    /
      DATA AE13CS( 47) / +.33544574090520678532907007999999D-29    /
      DATA AE13CS( 48) / -.90598868521070774437543935999999D-30    /
      DATA AE13CS( 49) / +.24524147051474238587273216000000D-30    /
      DATA AE13CS( 50) / -.66528178733552062817107967999999D-31    /
C
C SERIES FOR AE14       ON THE INTERVAL  0.          TO  2.50000D-01
C                                        WITH WEIGHTED ERROR   5.07D-32
C                                         LOG WEIGHTED ERROR  31.30
C                               SIGNIFICANT FIGURES REQUIRED  30.40
C                                    DECIMAL PLACES REQUIRED  32.20
C
c++ Save data by elements if ~.C.
      DATA AE14CS(  1) / -.1892918000753016825495679942820D+0      /
      DATA AE14CS(  2) / -.8648117855259871489968817056824D-1      /
      DATA AE14CS(  3) / +.7224101543746594747021514839184D-2      /
      DATA AE14CS(  4) / -.8097559457557386197159655610181D-3      /
      DATA AE14CS(  5) / +.1099913443266138867179251157002D-3      /
      DATA AE14CS(  6) / -.1717332998937767371495358814487D-4      /
      DATA AE14CS(  7) / +.2985627514479283322825342495003D-5      /
      DATA AE14CS(  8) / -.5659649145771930056560167267155D-6      /
      DATA AE14CS(  9) / +.1152680839714140019226583501663D-6      /
      DATA AE14CS( 10) / -.2495030440269338228842128765065D-7      /
      DATA AE14CS( 11) / +.5692324201833754367039370368140D-8      /
      DATA AE14CS( 12) / -.1359957664805600338490030939176D-8      /
      DATA AE14CS( 13) / +.3384662888760884590184512925859D-9      /
      DATA AE14CS( 14) / -.8737853904474681952350849316580D-10     /
      DATA AE14CS( 15) / +.2331588663222659718612613400470D-10     /
      DATA AE14CS( 16) / -.6411481049213785969753165196326D-11     /
      DATA AE14CS( 17) / +.1812246980204816433384359484682D-11     /
      DATA AE14CS( 18) / -.5253831761558460688819403840466D-12     /
      DATA AE14CS( 19) / +.1559218272591925698855028609825D-12     /
      DATA AE14CS( 20) / -.4729168297080398718476429369466D-13     /
      DATA AE14CS( 21) / +.1463761864393243502076199493808D-13     /
      DATA AE14CS( 22) / -.4617388988712924102232173623604D-14     /
      DATA AE14CS( 23) / +.1482710348289369323789239660371D-14     /
      DATA AE14CS( 24) / -.4841672496239229146973165734417D-15     /
      DATA AE14CS( 25) / +.1606215575700290408116571966188D-15     /
      DATA AE14CS( 26) / -.5408917538957170947895023784252D-16     /
      DATA AE14CS( 27) / +.1847470159346897881370231402310D-16     /
      DATA AE14CS( 28) / -.6395830792759094470500610425050D-17     /
      DATA AE14CS( 29) / +.2242780721699759457250233276170D-17     /
      DATA AE14CS( 30) / -.7961369173983947552744555308646D-18     /
      DATA AE14CS( 31) / +.2859308111540197459808619929272D-18     /
      DATA AE14CS( 32) / -.1038450244701137145900697137446D-18     /
      DATA AE14CS( 33) / +.3812040607097975780866841008319D-19     /
      DATA AE14CS( 34) / -.1413795417717200768717562723696D-19     /
      DATA AE14CS( 35) / +.5295367865182740958305442594815D-20     /
      DATA AE14CS( 36) / -.2002264245026825902137211131439D-20     /
      DATA AE14CS( 37) / +.7640262751275196014736848610918D-21     /
      DATA AE14CS( 38) / -.2941119006868787883311263523362D-21     /
      DATA AE14CS( 39) / +.1141823539078927193037691483586D-21     /
      DATA AE14CS( 40) / -.4469308475955298425247020718489D-22     /
      DATA AE14CS( 41) / +.1763262410571750770630491408520D-22     /
      DATA AE14CS( 42) / -.7009968187925902356351518262340D-23     /
      DATA AE14CS( 43) / +.2807573556558378922287757507515D-23     /
      DATA AE14CS( 44) / -.1132560944981086432141888891562D-23     /
      DATA AE14CS( 45) / +.4600574684375017946156764233727D-24     /
      DATA AE14CS( 46) / -.1881448598976133459864609148108D-24     /
      DATA AE14CS( 47) / +.7744916111507730845444328478037D-25     /
      DATA AE14CS( 48) / -.3208512760585368926702703826261D-25     /
      DATA AE14CS( 49) / +.1337445542910839760619930421384D-25     /
      DATA AE14CS( 50) / -.5608671881802217048894771735210D-26     /
      DATA AE14CS( 51) / +.2365839716528537483710069473279D-26     /
      DATA AE14CS( 52) / -.1003656195025305334065834526856D-26     /
      DATA AE14CS( 53) / +.4281490878094161131286642556927D-27     /
      DATA AE14CS( 54) / -.1836345261815318199691326958250D-27     /
      DATA AE14CS( 55) / +.7917798231349540000097468678144D-28     /
      DATA AE14CS( 56) / -.3431542358742220361025015775231D-28     /
      DATA AE14CS( 57) / +.1494705493897103237475066008917D-28     /
      DATA AE14CS( 58) / -.6542620279865705439739042420053D-29     /
      DATA AE14CS( 59) / +.2877581395199171114340487353685D-29     /
      DATA AE14CS( 60) / -.1271557211796024711027981200042D-29     /
      DATA AE14CS( 61) / +.5644615555648722522388044622506D-30     /
      DATA AE14CS( 62) / -.2516994994284095106080616830293D-30     /
      DATA AE14CS( 63) / +.1127259818927510206370368804181D-30     /
      DATA AE14CS( 64) / -.5069814875800460855562584719360D-31     /
C
C     ------------------------------------------------------------------
C
      X = XIN
      IF (NTAE10 .eq. 0) THEN
         BIGNUM = D1MACH(2)
         ETA = 0.1D0 * D1MACH(3)
         call DINITS(AE10CS, 50, ETA, NTAE10)
         call DINITS(AE11CS, 60, ETA, NTAE11)
         call DINITS(AE12CS, 41, ETA, NTAE12)
         call DINITS( E11CS, 29, ETA, NTE11 )
         call DINITS( E12CS, 25, ETA, NTE12 )
         call DINITS(AE13CS, 50, ETA, NTAE13)
         call DINITS(AE14CS, 64, ETA, NTAE14)
C
C     SETTING XMAX TO AVOID UNDERFLOW.
C
         EARG1 = -log(D1MACH(1))
         XMAX = (EARG1 - log(EARG1)) * FAC
C
C     SETTING XMIN TO AVOID OVERFLOW.
C
         EARG2 = log(BIGNUM)
         DELTA = log(EARG2)
         XMIN = -(EARG2 + DELTA) * FAC
      END IF
C
      IF (X.LE.(-1.D0)) THEN
         IF (X.LE.(-32.D0)) THEN
            IF (X .LT. XMIN) THEN
              CALL DERM1( NAME,1,0,MSG1,'X',XIN,',' )
              CALL DERV1('Limit |X|', XMIN,'.')
              DE1 = -BIGNUM
            ELSE
              DE1 = exp(-X-DELTA) * (EARG2/X) *
     *           (1.D0+DCSEVL(64.D0/X+1.D0,AE10CS,NTAE10))
            END IF
         ELSE IF (X.LE.(-8.D0)) THEN
            DE1 = exp(-X)/X * (1.D0+DCSEVL((64.D0/X+5.D0)/3.D0, AE11CS,
     1         NTAE11))
         ELSE IF (X.LE.(-4.D0)) THEN
            DE1 = exp(-X)/X*(1.D0+DCSEVL(16.D0/X+3.D0, AE12CS, NTAE12))
         ELSE
            DE1 = -log(-X) + DCSEVL((2.D0*X+5.D0)/3.D0, E11CS, NTE11)
         END IF
      ELSE IF (X .LE. 1.0D0) THEN
         IF (X .EQ. ZERO) THEN
           CALL ERMSG( NAME,2,0,MSG2,'.' )
           DE1 = BIGNUM
         ELSE
           DE1 = (-log(abs(X)) - 0.6875D0 + X) + DCSEVL(X,E12CS,NTE12)
         END IF
      ELSE IF (X.LE.4.0D0) THEN
         DE1 = exp(-X)/X * (1.D0 + DCSEVL((8.D0/X-5.D0)/3.D0, AE13CS,
     1      NTAE13))
      ELSE IF (X.LE.XMAX) THEN
         DE1 = exp(-X)/X * (1.D0 + DCSEVL(8.D0/X-1.D0, AE14CS, NTAE14))
      ELSE
         CALL DERM1( NAME,3,0,MSG3,'X',XIN,',' )
         CALL DERV1('Limit |X|', XMAX,'.')
         DE1 = ZERO
      END IF
C
      RETURN
C
      END
