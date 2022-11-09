
vizdf = function(x, tz="EST") {
 cpu_active = function(x)
   data.frame(tm = as.POSIXct(x$sampdate, tz=tz), xtype="CPU_MEM", 
     pos="top", value = 100-x$`CPU_Idle%`, type="%CPU active")
 mem_used = function(x)
   data.frame(tm = as.POSIXct(x$sampdate, tz=tz), xtype="CPU_MEM", 
     pos="bot", value = x$MEM_Used, type="MEM used")
 net_KB_cum = function(x)
   data.frame(tm = as.POSIXct(x$sampdate, tz=tz), xtype="NET_DSK",  
     pos="top", value = (x$NET_RxKBTot+x$NET_TxKBTot), type="KB NET")
 dsk_KBwr_cum = function(x)
   data.frame(tm = as.POSIXct(x$sampdate, tz=tz), xtype="NET_DSK", 
     pos="bot", value = cumsum(x$DSK_WriteKBTot), type="Cumul KB disk")
 
 rbind(cpu_active(x), mem_used(x), net_KB_cum(x), dsk_KBwr_cum(x))
}

#' elementary display of usage data from collectl
#' @import ggplot2
#' @param x output of cl_parse
#' @return ggplot with geom_point and facet_grid
#' @examples
#' lk = cl_parse(system.file("demotab/demo_1123.tab.gz", package="Rcollectl"))
#' plot_usage(lk)
#' @export
plot_usage = function(x) {
  ggplot(vizdf(x), aes(x=tm, y=value)) + geom_point() + 
          facet_grid(vars(type), scales="free")
}
