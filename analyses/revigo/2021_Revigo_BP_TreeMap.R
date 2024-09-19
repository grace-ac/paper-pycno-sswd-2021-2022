# A treemap R script produced by the Revigo server at http://revigo.irb.hr/
# If you found Revigo useful in your work, please cite the following reference:
# Supek F et al. "REVIGO summarizes and visualizes long lists of Gene Ontology
# terms" PLoS ONE 2011. doi:10.1371/journal.pone.0021800

# author: Anton Kratz <anton.kratz@gmail.com>, RIKEN Omics Science Center, Functional Genomics Technology Team, Japan
# created: Fri, Nov 02, 2012  7:25:52 PM
# last change: Fri, Nov 09, 2012  3:20:01 PM

# -----------------------------------------------------------------------------
# If you don't have the treemap package installed, uncomment the following line:
# install.packages( "treemap" );
library(treemap) 								# treemap package by Martijn Tennekes

# Set the working directory if necessary
# setwd("C:/Users/username/workingdir");

# --------------------------------------------------------------------------
# Here is your data from Revigo. Scroll down for plot configuration options.

revigo.names <- c("term_ID","description","frequency","value","uniqueness","dispensability","representative");
revigo.data <- rbind(c("GO:0006629","lipid metabolic process",5.904682497366825,1.287831049,0.964939245089928,0.05481122,"lipid metabolic process"),
c("GO:0007220","Notch receptor processing",0.007694756052677755,2.394560856,0.9450183808561058,0.0836589,"Notch receptor processing"),
c("GO:0001732","formation of cytoplasmic translation initiation complex",0.08812465515825396,2.095240749,0.8191215866244811,0.45127865,"Notch receptor processing"),
c("GO:0002181","cytoplasmic translation",0.30687006719783905,1.975512706,0.8954788395393712,0.20834333,"Notch receptor processing"),
c("GO:0006412","translation",4.79105045597284,1.275363934,0.8740990689301211,0.40011842,"Notch receptor processing"),
c("GO:0006413","translational initiation",0.5198767836206222,1.469389616,0.8909920870757386,0.52378989,"Notch receptor processing"),
c("GO:0006508","proteolysis",5.47471837344373,1.162893784,0.9063745445184078,0.53488925,"Notch receptor processing"),
c("GO:0007517","muscle organ development",0.07039062554454588,1.687076967,0.9022344169349548,-0,"muscle organ development"),
c("GO:0007275","multicellular organism development",1.8291561938226675,1.161717643,0.8865029788862901,0.61906026,"muscle organ development"),
c("GO:0030324","lung development",0.02279774662939793,1.392186544,0.8943102439721449,0.60327197,"muscle organ development"),
c("GO:0031100","animal organ regeneration",0.0021792166264475842,1.665781465,0.9218035680331755,0.5245573,"muscle organ development"),
c("GO:0015701","bicarbonate transport",0.02769891777788118,2.394560856,0.9338252030840641,-0,"bicarbonate transport"),
c("GO:0006821","chloride transport",0.2849869854483154,1.568850216,0.9310957794388464,0.21599314,"bicarbonate transport"),
c("GO:0015881","creatine transmembrane transport",0.0006915086893025837,2.128498539,0.9288993834625409,0.45165977,"bicarbonate transport"),
c("GO:0035725","sodium ion transmembrane transport",0.4213299078582579,1.358109142,0.9165882922976007,0.50086395,"bicarbonate transport"),
c("GO:0140115","export across plasma membrane",0.14435175013823975,2.128498539,0.9270311616928514,0.18181693,"bicarbonate transport"),
c("GO:0034418","urate biosynthetic process",0.00019560604358758346,2.394560856,0.9518856853496185,0.02620869,"urate biosynthetic process"),
c("GO:0006107","oxaloacetate metabolic process",0.03491981130243127,2.128498539,0.9479286864737588,0.26180056,"urate biosynthetic process"),
c("GO:0006633","fatty acid biosynthetic process",0.826237173099254,1.484627731,0.913669743343025,0.55827172,"urate biosynthetic process"),
c("GO:0043651","linoleic acid metabolic process",0.005471459191055504,2.128498539,0.9468410009999758,0.14106123,"urate biosynthetic process"),
c("GO:0044550","secondary metabolite biosynthetic process",0.4384964044440921,2.195014118,0.9637769097821737,0.09430318,"secondary metabolite biosynthetic process"),
c("GO:0098742","cell-cell adhesion via plasma-membrane adhesion molecules",0.26452824629787325,2.394560856,0.9568448097428646,0.01396231,"cell-cell adhesion via plasma-membrane adhesion molecules"),
c("GO:1902043","positive regulation of extrinsic apoptotic signaling pathway via death domain receptors",0.0011819013056207507,2.394560856,0.8521346449309873,-0,"positive regulation of extrinsic apoptotic signaling pathway via death domain receptors"),
c("GO:0007162","negative regulation of cell adhesion",0.05305331804740978,1.874004148,0.8756227836271941,0.40342965,"positive regulation of extrinsic apoptotic signaling pathway via death domain receptors"),
c("GO:0008285","negative regulation of cell population proliferation",0.10600745556567656,1.232288628,0.858778007701153,0.44997615,"positive regulation of extrinsic apoptotic signaling pathway via death domain receptors"),
c("GO:0010508","positive regulation of autophagy",0.051805296389027033,1.534974908,0.8522807846183375,0.42494684,"positive regulation of extrinsic apoptotic signaling pathway via death domain receptors"),
c("GO:0010628","positive regulation of gene expression",0.43212405544665444,1.197280428,0.8307574295526406,0.60480373,"positive regulation of extrinsic apoptotic signaling pathway via death domain receptors"),
c("GO:0016525","negative regulation of angiogenesis",0.02170676080882493,1.482347197,0.8481945665052194,0.63253805,"positive regulation of extrinsic apoptotic signaling pathway via death domain receptors"),
c("GO:0030334","regulation of cell migration",0.1980277015074917,1.496600535,0.8826352745002806,0.14013626,"positive regulation of extrinsic apoptotic signaling pathway via death domain receptors"),
c("GO:0031397","negative regulation of protein ubiquitination",0.015959800147927757,1.831134772,0.8692877972436053,0.6947622,"positive regulation of extrinsic apoptotic signaling pathway via death domain receptors"),
c("GO:0032956","regulation of actin cytoskeleton organization",0.27920971962573565,1.436736514,0.885871710018717,0.17985872,"positive regulation of extrinsic apoptotic signaling pathway via death domain receptors"),
c("GO:0033674","positive regulation of kinase activity",0.0017549443628914177,1.690278251,0.8721748235042112,0.31171705,"positive regulation of extrinsic apoptotic signaling pathway via death domain receptors"),
c("GO:0043066","negative regulation of apoptotic process",0.1868395868172216,1.246483733,0.8507348685152731,0.61717905,"positive regulation of extrinsic apoptotic signaling pathway via death domain receptors"),
c("GO:0045672","positive regulation of osteoclast differentiation",0.0033280577556873353,1.756011294,0.8483130957687444,0.45870928,"positive regulation of extrinsic apoptotic signaling pathway via death domain receptors"),
c("GO:0045861","negative regulation of proteolysis",0.026798027971498932,2.075286075,0.8700878868121886,0.10346468,"positive regulation of extrinsic apoptotic signaling pathway via death domain receptors"),
c("GO:0045906","negative regulation of vasoconstriction",0.0011268010116524173,1.841969889,0.8213223737518404,0.32421844,"positive regulation of extrinsic apoptotic signaling pathway via death domain receptors"),
c("GO:0048167","regulation of synaptic plasticity",0.042986494339395276,1.412176915,0.8723992971906566,0.49533449,"positive regulation of extrinsic apoptotic signaling pathway via death domain receptors"),
c("GO:0051897","positive regulation of phosphatidylinositol 3-kinase/protein kinase B signal transduction",0.022387249439333845,1.394301258,0.843439938233263,0.55979563,"positive regulation of extrinsic apoptotic signaling pathway via death domain receptors"),
c("GO:1901222","regulation of non-canonical NF-kappaB signal transduction",0.012405831186970256,1.959186155,0.8933076743842339,0.42139897,"positive regulation of extrinsic apoptotic signaling pathway via death domain receptors"),
c("GO:1905037","autophagosome organization",0.133020374683652,2.394560856,0.8053304664775849,-0,"autophagosome organization"),
c("GO:0001764","neuron migration",0.0346277797443991,1.281595951,0.850879890868617,0.60312586,"autophagosome organization"),
c("GO:0003341","cilium movement",0.09705365779582238,1.702798831,0.9436468672791462,0.52374641,"autophagosome organization"),
c("GO:0006198","cAMP catabolic process",0.012662047553923007,2.394560856,0.898898819076284,0.38137839,"autophagosome organization"),
c("GO:0006909","phagocytosis",0.0643461232962197,1.496600535,0.9056683632313668,0.67302758,"autophagosome organization"),
c("GO:0007034","vacuolar transport",0.33345320402286144,2.394560856,0.8888910080960429,0.32020367,"autophagosome organization"),
c("GO:0007043","cell-cell junction assembly",0.06610933270320637,1.841969889,0.882514060032415,0.63707655,"autophagosome organization"),
c("GO:0008104","protein localization",3.769766507269781,1.306124103,0.8643550638913987,0.62779619,"autophagosome organization"),
c("GO:0008333","endosome to lysosome transport",0.04040780058167727,1.518502006,0.8890277377043945,0.52897974,"autophagosome organization"),
c("GO:0015721","bile acid and bile salt transport",0.00689580179013692,1.638383744,0.9073598135875283,0.67435745,"autophagosome organization"),
c("GO:0030036","actin cytoskeleton organization",0.625278135952647,1.255213352,0.8762088947841633,0.66932856,"autophagosome organization"),
c("GO:0031638","zymogen activation",0.021841756529047348,1.824427319,0.898575402972966,0.34997846,"autophagosome organization"),
c("GO:0032367","intracellular cholesterol transport",0.01303121952351084,2.128498539,0.8938488990529376,0.48811462,"autophagosome organization"),
c("GO:0042953","lipoprotein transport",0.021296263618760844,1.841969889,0.9025043964185969,0.39826774,"autophagosome organization"),
c("GO:0043149","stress fiber assembly",0.00512708235375342,2.176873505,0.8984124185607202,0.41726048,"autophagosome organization"),
c("GO:0043162","ubiquitin-dependent protein catabolic process via the multivesicular body sorting pathway",0.07008481891302162,2.394560856,0.8817298002704032,0.3321102,"autophagosome organization"),
c("GO:0043652","engulfment of apoptotic cell",0.02053036953260101,1.959186155,0.8398986567521567,0.55122693,"autophagosome organization"),
c("GO:0045332","phospholipid translocation",0.06575118079241221,1.881440673,0.7379107419742584,0.59961398,"autophagosome organization"),
c("GO:0048813","dendrite morphogenesis",0.013270905802273091,1.47899347,0.8294963514378478,0.66301305,"autophagosome organization"),
c("GO:0051085","chaperone cofactor-dependent protein refolding",0.10448393243745215,1.729405063,0.8996917512591416,0.51696684,"autophagosome organization"),
c("GO:0055085","transmembrane transport",13.668162391696583,1.210341669,0.8951595146286966,0.3481583,"autophagosome organization"),
c("GO:0071340","skeletal muscle acetylcholine-gated channel clustering",0.0006749786011120837,2.394560856,0.8480041127195954,0.21389952,"autophagosome organization"),
c("GO:0071711","basement membrane organization",0.005791040896071836,1.729405063,0.9237161952697932,0.24196911,"autophagosome organization"),
c("GO:0090110","COPII-coated vesicle cargo loading",0.027748508042452685,2.176873505,0.8162980542479387,0.51466967,"autophagosome organization"),
c("GO:1902287","semaphorin-plexin signaling pathway involved in axon guidance",0.011077914102333424,2.052480734,0.6875209225248944,0.51593621,"autophagosome organization"),
c("GO:1904158","axonemal central apparatus assembly",0.00557339473489692,2.394560856,0.8522103693374712,0.33206211,"autophagosome organization"),
c("GO:1990834","response to odorant",0.0019698355093679177,2.394560856,0.9137258845180034,0,"response to odorant"),
c("GO:0006805","xenobiotic metabolic process",0.11171309100609747,1.361613036,0.8454073426860459,0.48167717,"response to odorant"),
c("GO:0006986","response to unfolded protein",0.10853104902942623,1.544877972,0.9087865068984394,0.34194875,"response to odorant"),
c("GO:0007165","signal transduction",8.83948118995807,1.117116944,0.7592820928395833,0.65887636,"response to odorant"),
c("GO:0007166","cell surface receptor signaling pathway",1.515836637215835,1.368320489,0.7916442588596152,0.34165578,"response to odorant"),
c("GO:0007169","cell surface receptor protein tyrosine kinase signaling pathway",0.2759009469729372,1.596373904,0.7908509818713834,0.6382183,"response to odorant"),
c("GO:0007189","adenylate cyclase-activating G protein-coupled receptor signaling pathway",0.13929354315194675,1.354817326,0.8252379586919326,0.41084801,"response to odorant"),
c("GO:0007219","Notch signaling pathway",0.08708050458755405,1.278649001,0.8061507770852687,0.58595313,"response to odorant"),
c("GO:0007229","integrin-mediated signaling pathway",0.08797037433514263,1.632655129,0.8060252241181,0.56233532,"response to odorant"),
c("GO:0009410","response to xenobiotic stimulus",0.13023229980885434,1.197280428,0.8897740344106453,0.48750621,"response to odorant"),
c("GO:0009615","response to virus",0.16725418732617753,1.596373904,0.8874071602967423,0.62433196,"response to odorant"),
c("GO:0034097","response to cytokine",0.24023728170193348,1.85034248,0.8785313003462137,0.366358,"response to odorant"),
c("GO:0042542","response to hydrogen peroxide",0.09070334891597197,1.729405063,0.875275008426983,0.53301571,"response to odorant"),
c("GO:0043627","response to estrogen",0.009444190386172339,1.571430562,0.9032465987461904,0.47056606,"response to odorant"),
c("GO:0050829","defense response to Gram-negative bacterium",0.02159931523558668,1.696147273,0.8849944565753134,0.17514678,"response to odorant"),
c("GO:0071318","cellular response to ATP",0.001261796731874834,2.394560856,0.8934852078751264,0.27940279,"response to odorant"),
c("GO:0071526","semaphorin-plexin signaling pathway",0.04820173716349803,1.819866251,0.813194217743442,0.50331494,"response to odorant"),
c("GO:0097192","extrinsic apoptotic signaling pathway in absence of ligand",0.015742153986752844,1.841969889,0.8252444519396203,0.15373828,"response to odorant"));

stuff <- data.frame(revigo.data);
names(stuff) <- revigo.names;

stuff$value <- as.numeric( as.character(stuff$value) );
stuff$frequency <- as.numeric( as.character(stuff$frequency) );
stuff$uniqueness <- as.numeric( as.character(stuff$uniqueness) );
stuff$dispensability <- as.numeric( as.character(stuff$dispensability) );

# by default, outputs to a PDF file
pdf( file="revigo_treemap.pdf", width=16, height=9 ) # width and height are in inches

# check the tmPlot command documentation for all possible parameters - there are a lot more
treemap(
  stuff,
  index = c("representative","description"),
  vSize = "value",
  type = "categorical",
  vColor = "representative",
  title = "Revigo TreeMap",
  inflate.labels = FALSE,      # set this to TRUE for space-filling group labels - good for posters
  lowerbound.cex.labels = 0,   # try to draw as many labels as possible (still, some small squares may not get a label)
  bg.labels = "#CCCCCCAA",   # define background color of group labels
								 # "#CCCCCC00" is fully transparent, "#CCCCCCAA" is semi-transparent grey, NA is opaque
  position.legend = "none"
)

dev.off()

