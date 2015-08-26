#============================================================================#
# This code is to filter out patent data stored in a CSV file by Top30 assignees
# 
# Input:  1. A CSV format file including SN, patent number, title, claim, abstract, 
#            assignee, assginee's address, assignee's country, and data source.
#
# Return: A filtered patent data in xlsx format including SN, patent number, 
#         resource, title, assignee's name, assignee's adderss, 
#         assignee's country, claim, and abstract associated with the 
#         target patent numbers.
#
# Alf Tang
#============================================================================#

library("openxlsx") # Load package to deal with xlsx file
library("stringr") # Load package to deal with text string

# Set zip path so R could use write.xlsx requiring zip tool in Rtools
Sys.setenv(R_ZIPCMD = "C:/Program Files/Rtools/bin/zip")

assigneeName <- list(
    # Top1
    threeM <- c("3m innovative properties company", 
                "3m新設資產公司",
                "3m创新有限公司"),
    # Top2
    mitsui <- c("mitsui chemicals inc",
                "三井化学株式会社",
                "三井化學股份有限公司"),
    # Top3
    dupont <- c("du pont de nemours",
                "杜邦股份有限公司",
                "纳幕尔杜邦公司"),
    # Top4
    kaneka <- c("kaneka corp",
                "kaneka株式会社"),
    # Top5
    kimberly <- c("kimberly clark worldwide inc",
                  "金百利克拉克股份有限公司"),
    # Top6
    shin.etsu <- c("shin etsu",
                   "shinetsu chemical co ltd"),
    # Top7
    toyobo <- c("toyobo co ltd"), # "TOYO BOSEKI KABUSHIKI KAISHA" is not counted
    # Top8
    dow.global <- c("dow global technologies llc"),
    # Top9
    ibmc <- c("international business machines corporation"),
    # Top10
    dow.corning <- c("dow corning",
                     "道康宁公司"),
    # Top11
    exxonMobil <- c("exxonmobil chemical patents inc",
                    "埃克森美孚化学专利公司"),
    # Top12
    nitto <- c("nitto denko corp"),
    # Top12
    kuraray <- c("kuraray co ltd"),
    # Top13
    dupont.toray <- c("duponttoray",
                      "東麗杜邦有限公司",
                      "dupont toray",
                      "du pont toray",
                      "du ponttoray",
                      "toraydupont"),
    # Top14
    itri <- c("財團法人工業技術研究院"),  
    # Top15
    nippon <- c("nippon steel",
                "新日鐵",
                "新日铁"),
    # Top16
    ajinomoto <- c("ajinomoto co inc"),
    # Top17
    asahi <- c("asahi kasei",
               "旭化成"),
    # Top18
    mitsubishi <- c("mitsubishi chemical corporation"),
    # Top19
    jsr <- c("jsr corp"),
    # Top20
    sumitomo <- c("sumitomo bakelite"),
    # Top21
    chinaPetro <- c("中国石油化工股份有限公司"),
    # Top22
    hitachi <- c("hitachi chem",
                 "hitachi ltd", 
                 "日立化成"),
    # Top23
    yokohama <- c("yokohama rubber co ltd"),
    # Top24
    wacker <- c("wacker chemie ag"),
    # Top25
    trustees.illinoise <- c("the board of trustees of the university of illinois"),
    # Top26
    toray <- c("toray ind inc",
               "toray industries inc",
               "东丽株式会社"),
    # Top27
    sabic <- c("sabic innovative plastics ip bv"),
    # Top28
    chinaPetroRes <- c("中国石油化工股份有限公司北京化工研究院"),
    # Top 29
    canon <- c("canon kabushiki kaisha",
               "佳能株式会社"),
    # Top30
    arkema <- c("arkema france"),
    # Top31
    dainichiseika <- c("dainichiseika"),
    # Top32
    henkel <- c("henkel ag co kgaa"),
    # Top33
    ukima <- c("ukima chem"),
    # Top34
    riken <- c("riken technos"),
    # Top35
    nipponZeon <- c("nippon zeon co ltd"),
    # Top36
    philips <- c("koninklijke philips electronics nv")
)
# Load raw data to "rawData"
rawData <- read.csv("rawdata.csv")

# Remove all punctuations and convert all letters to lower case in assignee list
tmpAssignee <- tolower(gsub("[[:punct:]]", "", rawData$Assignee))

# Create an empty data frame to store output
output <- data.frame(matrix(vector(), 0, length(dim(rawData)[2])))
# Search (Top 30) assignees' name one by one in the assignee list "tmpAssignee"
# If an element in top 30 assignees' name is contained in tmpAssignee, 
# then store the matched patent information to output.
for (i in 1:length(assigneeName)) {
    for (j in 1:length(assigneeName[[i]])) {
        output <- rbind(output, rawData[grep(assigneeName[[i]][j], tmpAssignee),])
    }
}
# Ordering the result by databases, starting by USPTO
output <- output[order(output$source, decreasing = TRUE),]

# Write the result to xlsx format
write.xlsx(output, file="output.xlsx")

# Top30 Assignees in the faiflex project
top30Assignee <- c(
    "3M Innovative Properties Company",
    "三井化學股份有限公司 (Mitsui Chemical)",
    "E. I. duPont de Nemours and Company",
    "Kaneka Corp",
    "Kimberly-Clark", 
    "Shin-Etsu Chemical",
    "Toyobo Co. Ltd.",
    "Dow Global Technologies Inc.",
    "International Business Machines Corporation",
    "Dow Corning Corporation",
    "ExxonMobil Chemical Patents Inc.",
    "Nitto Denko Corporation",
    "Kuraray Co. Ltd.",
    "Dupont-Toray Company, Ltd.",
    "Industrial Technology Research Institute",
    "Nippon Steel Chem Co. Ltd.",
    "Ajinomoto Co. Inc.",
    "Asahi Kasei Chemicals Corp.",
    "Mitsubishi Chemicals Corp.",
    "JSR Corp",
    "Sumitomo Bakelite Co. Ltd.",
    "中國石油化工股份有限公司",
    "Hitachi Chem Co. Ltd.",
    "Yokohama Rubber Co. Ltd.",
    "Wacker Chemie AG",
    "The Board of Trustees of the University of Illinois",
    "Toray Industries Inc.",
    "Sabic Innovative Plastics IP B.V.",
    "中國石油化工股份有限公司北京化工研究院",
    "Canon Kabushiki Kaisha",
    "Arkema France",
    "Dainichiseika Color & Chem MFG Co. Ltd.",
    "Henkel AG & Co. KGaA",
    "Ukima Chem & Colour MFG Co. Ltd.",
    "Riken Technos Corp.",
    "Nippon Zeon Co Ltd",
    "Koninklijke Philips Electronics N. V. (飛利浦)")
