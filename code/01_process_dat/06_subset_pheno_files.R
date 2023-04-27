# Create the phenotype files for the validation set only.

library(magrittr)

scenario_vec <- c("I", "II", "III", "IV")
distribution_vec <- c("laplace", "normal", "scaledt")
hsq_vec <- c(0.1, 0.2, 0.5)

# read the ids for validation set
ids_file <- here::here("subset_subjects", "subjects_for_sims_validation-136k.txt")
ids <- vroom::vroom(ids_file, col_names = FALSE)

for (scenario in scenario_vec){
    for (distribution in distribution_vec){
        for (hsq in hsq_vec){
            mydir <- here::here("validation", paste0("scenario", scenario), distribution, paste0("hsq", hsq))
            if (!(dir.exists(mydir))){
                dir.create(mydir, recursive = TRUE)
            }
            # read trait file for all subjects
            trait_file <- here::here("sim_traits", paste0("sims_scenario", scenario, "_", distribution, "_hsq", hsq, ".txt"))
            traits <- vroom::vroom(trait_file, col_names = FALSE)
            for (phe_num in 1:10){
                outfile <- paste0(mydir, "/pheno_", phe_num, ".txt")
                traits %>%
                    dplyr::select(tidyselect::all_of(c(1, 2, 2 + phe_num))) %>%
                    dplyr::right_join(ids, by = c("X1", "X2")) %>%
                    dplyr::select( - c(1,2)) %>%
                    vroom::vroom_write(file = outfile, col_names = FALSE)
            }
        }
    }
}
