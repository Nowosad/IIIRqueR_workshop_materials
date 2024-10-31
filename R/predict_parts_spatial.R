predict_parts_spatial = function(x, exp, maxcell = 1000, type = "break_down"){
    if (terra::ncell(x) > 1.1 * maxcell) {
        x = terra::spatSample(x, maxcell, method = "regular", as.raster = TRUE, warn = FALSE)
    }
    x_df = as.data.frame(x, na.rm = FALSE)
    result = cbind(intercept = NA, x_df, pred = NA)
    for (i in seq_len(nrow(x_df))){
        if (complete.cases(x_df[i, ])){
            pp = DALEX::predict_parts(exp, new_observation = x_df[i, ], type = type)
            pp_df = data.frame(contribution = pp$contribution, variable_name = pp$variable_name, label = pp$label)
            pp_df$variable_name = ifelse(pp_df$variable_name == "", "pred", pp_df$variable_name)
            pp_df = tidyr::pivot_wider(pp_df, names_from = variable_name, values_from = contribution)
            result[i, ] = pp_df[which.max(pp_df$pred), names(result)]
        } else {
            result[i, ] = NA
        }
    }
    r_result = terra::rast(x, nlyrs = ncol(result))
    terra::values(r_result) = result
    names(r_result) = names(result)
    return(r_result)
}