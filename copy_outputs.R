


library(tidyverse)


plan_names <- c("MEPERS", "SDRS", "TCRS", "NESERS", "WRS")

dir_workingVer <- "latestVer_working"
dir_sharedVer  <- "latestVer_shared"
dir_web  <- "docs"

copy_outputs <- function(plan_name, dir_to, shared_ver = FALSE){

# plan_name <- "NESERS"
# dir_to    <- "latestVer_working" 
# shared_ver <- TRUE

fn <- 
	data.frame(
	planName = plan_name, 
	fn = dir(paste0("../model_", plan_name, "/analysis/"), "nb.html")) %>% 
	filter(str_detect(fn, paste0(plan_name, "_v\\("))) %>% 
	mutate(ver = str_extract(fn, "\\(.+\\)"),
				 ver = str_remove(ver, "[\\(]"),
         ver = str_remove(ver, "[)]"),
				 ver = as.numeric(ver))

if(shared_ver){
	fn <- 
	  fn %>% 
		filter(ver == round(ver))
	
	if (nrow(fn) == 0) return(paste0("No shared version for ", plan_name)) 
}

fn <- 
  fn %>% 
	filter(ver == max(ver)) %>% 
	pull(fn)

fn_path <- paste0("../model_", plan_name, "/analysis/", fn)

file.copy(fn_path, dir_to, overwrite = TRUE)

return(paste0("file coplied: ", fn))

}



map(plan_names, copy_outputs, dir_workingVer)

map(plan_names, copy_outputs, dir_sharedVer, shared_ver = TRUE)

map(plan_names, copy_outputs, dir_web, shared_ver = TRUE)
