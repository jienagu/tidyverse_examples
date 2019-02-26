
### This is a demo of long to wide data frame
### Usually, when you copy and paste a contact list from a contact book to a csv, you will have one column with all
### member's contact info (long format, very messy)
### Now you want to have a data frame with cols: company name; owner; address; emails; phone... So that you can sort the data

### Here is a demo of how to do it

### df1 is the raw long and messy data frame from contact list

contact_list=c("company name A", "Jiena McLellan", "Manhattan, KS, 66502", "jm***@gmail.com", 769629292, "someone.com",
               "Prefix: BAG", "Member: 123",
               "company name B", "John Smith", "Topeka, KS, 66502", "jghh***@gmail.com", 4516497916, "someone2.com",
               "Prefix: BED", "Member: 459")

df1=data.frame(contact_list)

df1$group<-c(rep(1,8), rep(2,8))
df1$col_names<-c(rep(c("Company Name", "Owner", "Address", "Email", "Phone", "Web","Prefix", "Member ID"), 2 ) )

final_list<-spread(df1, col_names, contact_list)
