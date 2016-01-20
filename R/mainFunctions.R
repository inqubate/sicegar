#' @title fit function
#'
#' @param data Normalized input data that will be fitted transferred into related functions
#' @param model type of fit function that will be used. Can be "linear", "sigmoidal", "double_sigmoidal", "test"
#' @param n_runs_max number of maximum runs that the algorithm can run
#' @param n_runs_min number of minimum runs that the algorithm can run
#'
#' @details the algorithm calls the fitting algorithms. to make the fits with random initial parameters. This multiple runs are necessary to avoid local minimums that LM fits can stuck. Fitting algorithms can either gives a fit with related parameters and isThisaFit=TRUE value or just give isThisaFit=FALSE corresponding to not a fit. n_runs_min represent minimum number of fits that are necessary to give a result, n_runs_max limits the number of runs (successful or unsuccessful) that the it algorithm can run
#' @return The function returns the parameters related with fitted curve to input data
#' @export
#'
#' @examples
#' # Example 1 (test function without normalization)
#' # data sent to algorithm directly as data frame
#' # a- Generate data
#' time = seq(3,48,0.5)
#' intensity=runif(length(time), 3.0, 7.5)
#' dataInput = data.frame(time,intensity)
#' # b- generate "random Parameter" for model "test"
#' randomParameter=0.7 # it should be a parameter between 0 and 1
#' # c- use the function "test"
#' parameterOutput=fitFunction(data=dataInput,model="test",n_runs_min=5,n_runs_max=15)
#'
#' # Example 2 (test function with normalization)
#' # data sent to algorithm after normalization
#' # a- Generate data
#' time = seq(3,48,0.5)
#' intensity=runif(length(time), 3.0, 7.5)
#' dataInput = data.frame(time,intensity)
#' # b- normalize data
#' dataOutput = normalizeData(dataInput)
#' # c- generate "random Parameter" for model "test"
#' randomParameter=0.7 # it should be a parameter between 0 and 1
#' # d- use the function "test"
#' dataInput2=dataOutput
#' parameterOutput=fitFunction(data=dataInput2,
#'                                 model="test",
#'                                 n_runs_min=5,
#'                                 n_runs_max=15)
#'
#' # Example 3 (linear function without normalization)
#' # data sent to algorithm directly as data frame
#' # a- Generate data
#' time = seq(3,48,0.5)
#' intensity=runif(length(time), 3.0, 7.5)
#' dataInput = data.frame(time,intensity)
#' # b- use the function "linear"
#' parameterOutput=fitFunction(data=dataInput,
#'                                 model="linear",
#'                                 n_runs_min=5,
#'                                 n_runs_max=15)
#'
#'
#'# Example 4 (linear function with normalization)
#'# Initial Command to Reset the System
#'rm(list = ls())
#'if (is.integer(dev.list())){dev.off()}
#'cat("\014")
#'
#'time=seq(3,24,0.5)
#'
#'#intensity with Noise
#'noise_parameter=20
#'intensity_noise=runif(n = length(time),min = 0,max = 1)*noise_parameter
#'intensity=lineFitFormula(time, slope=4, intersection=-2)
#'intensity=intensity+intensity_noise
#'
#'dataInput=data.frame(intensity=intensity,time=time)
#'dataOutput = normalizeData(dataInput)
#'dataInput2=dataOutput
#'parameterVector=fitFunction(data=dataInput2,
#'                                model="linear",
#'                                 n_runs_min=5,
#'                                 n_runs_max=15)
#'
#'#Check the results
#'if(parameterVector$isThisaFit){
#'  intensityTheoretical=lineFitFormula(time,
#'                                      slope=parameterVector$slope_Estimate,
#'                                      intersection=parameterVector$intersection_Estimate)
#'
#'  comparisonData=cbind(dataInput,intensityTheoretical)
#'
#'  print(parameterVector$residual_Sum_of_Squares)
#'  require(ggplot2)
#'  ggplot(comparisonData)+
#'    geom_point(aes(x=time, y=intensity))+
#'    geom_line(aes(x=time,y=intensityTheoretical))+
#'    expand_limits(x = 0, y = 0)}
#'
#'if(!parameterVector$isThisaFit){print(parameterVector)}
#'
#'# Example 5 (sigmoidal function with normalization)
#'# Initial Command to Reset the System
#'rm(list = ls())
#'if (is.integer(dev.list())){dev.off()}
#'cat("\014")
#'
#'time=seq(3,24,0.5)
#'
#'#intensity with Noise
#'noise_parameter=2.5
#'intensity_noise=runif(n = length(time),min = 0,max = 1)*noise_parameter
#'intensity=sigmoidalFitFormula(time, maximum=4, slope=1, midPoint=8)
#'intensity=intensity+intensity_noise
#'
#'dataInput=data.frame(intensity=intensity,time=time)
#'dataOutput = normalizeData(dataInput)
#'dataInput2=dataOutput
#'parameterVector=fitFunction(data=dataInput2,
#'                                model="sigmoidal",
#'                                n_runs_min=20,
#'                                n_runs_max=500)
#'
#'#Check the results
#'if(parameterVector$isThisaFit){
#'  intensityTheoretical=sigmoidalFitFormula(time,
#'                                           maximum=parameterVector$maximum_Estimate,
#'                                           slope=parameterVector$slope_Estimate,
#'                                           midPoint=parameterVector$midPoint_Estimate)
#'
#'  comparisonData=cbind(dataInput,intensityTheoretical)
#'
#'  print(parameterVector$residual_Sum_of_Squares)
#'  require(ggplot2)
#'  ggplot(comparisonData)+
#'    geom_point(aes(x=time, y=intensity))+
#'    geom_line(aes(x=time,y=intensityTheoretical),color="orange")+
#'    expand_limits(x = 0, y = 0)}
#'
#'
#'
#'if(!parameterVector$isThisaFit){print(parameterVector)}
#'
#'
#'
#' # Example 6 (doublesigmoidal function with normalization)
#'# Initial Command to Reset the System
#'rm(list = ls())
#'if (is.integer(dev.list())){dev.off()}
#'cat("\014")
#'
#'time=seq(3,24,0.1)
#'
#'#intensity with Noise
#'noise_parameter=0.2
#'intensity_noise=runif(n = length(time),min = 0,max = 1)*noise_parameter
#'intensity=doublesigmoidalFitFormula(time,
#'                                    finalAsymptoteIntensity=.3,
#'                                    maximum=4,
#'                                    slope1=1,
#'                                    midPoint1=7,
#'                                    slope2=1,
#'                                    midPointDistance=8)
#'intensity=intensity+intensity_noise
#'
#'dataInput=data.frame(intensity=intensity,time=time)
#'dataOutput = normalizeData(dataInput)
#'dataInput2=dataOutput
#'parameterVector=fitFunction(data=dataInput2,
#'                                model="doublesigmoidal",
#'                                n_runs_min=20,
#'                                n_runs_max=500)
#'
#'
#'#Check the results
#'if(parameterVector$isThisaFit){
#'  intensityTheoretical=doublesigmoidalFitFormula(time,
#'                                                 finalAsymptoteIntensity=parameterVector$finalAsymptoteIntensity_Estimate,
#'                                                 maximum=parameterVector$maximum_Estimate,
#'                                                 slope1=parameterVector$slope1_Estimate,
#'                                                 midPoint1=parameterVector$midPoint1_Estimate,
#'                                                 slope2=parameterVector$slope2_Estimate,
#'                                                 midPointDistance=parameterVector$midPointDistance_Estimate)
#'
#'  comparisonData=cbind(dataInput,intensityTheoretical)
#'  require(ggplot2)
#'  ggplot(comparisonData)+
#'    geom_point(aes(x=time, y=intensity))+
#'    geom_line(aes(x=time,y=intensityTheoretical),color="orange")+
#'    expand_limits(x = 0, y = 0)}
#'
#'if(!parameterVector$isThisaFit){print(parameterVector)}
fitFunction <-
  function(dataInput,model, n_runs_min, n_runs_max, ...)
  {
    dataInputCheck=dataCheck(dataInput)

    if(!(model %in% c("linear", "sigmoidal", "doublesigmoidal", "test")) )
    {stop("model should be one of linear, sigmoidal, doublesigmoidal, test")}

    counterBetterFit=0
    counterCorrectFit=0
    counterTotalFit=0
    residual_Sum_of_Squares_min=Inf
    storedModelOutput=list()
    storedModelOutput$residual_Sum_of_Squares=Inf

    while(counterCorrectFit<n_runs_min & counterTotalFit<n_runs_max)
    {
      counterTotalFit=counterTotalFit+1
      if(model == "test"){modelOutput=exampleFitFunction(randomParameter)}
      if(model == "linear"){modelOutput=lineFitFunction(dataInput=dataInput,tryCounter=counterTotalFit)}
      if(model == "sigmoidal"){modelOutput=sigmoidalFitFunction(dataInput=dataInput,tryCounter=counterTotalFit)}
      if(model == "doublesigmoidal"){modelOutput=doublesigmoidalFitFunction(dataInput=dataInput,tryCounter=counterTotalFit)}

      if(modelOutput[["isThisaFit"]]){
        counterCorrectFit=counterCorrectFit+1
        if(residual_Sum_of_Squares_min>modelOutput$residual_Sum_of_Squares){
          counterBetterFit=counterBetterFit+1
          residual_Sum_of_Squares_min=modelOutput$residual_Sum_of_Squares
          storedModelOutput=modelOutput
        }
      }

      print(c(betterFit=counterBetterFit,
              correctFit=counterCorrectFit,
              totalFit=counterTotalFit,
              currentOutput=modelOutput$residual_Sum_of_Squares,
              bestOutput=storedModelOutput$residual_Sum_of_Squares))

    }
    return(storedModelOutput)
  }

#' exampleFitFunction
#'
#' @param randomParameter This parameter defines the probability that the exampleFitFunction returns TRUE values for isThisaFit parameter. The aparemeter should be in the interval of 0 and 1
#' @details This is the exampleFitFunction that generates TRUE values for isThisaFit parameter whit given probability
#' @return The function returns TRUE or FALSE for isThisaFit parameter and also residual_Sum_of_Squares parameter that determines the goodness of the fit
#'
#' @examples
#' # add usage examples here
exampleFitFunction<-
  function(randomParameter)
  {
    if(randomParameter<0 | randomParameter>1)
      {stop("the random parameter for model test should be between 0 and 1")}
    randomNumber=runif(1, 0, 1)
    if(randomNumber<randomParameter){isThisaFit=TRUE; residual_Sum_of_Squares=runif(1, 0, 1)}
    if(randomNumber>randomParameter){isThisaFit=FALSE; residual_Sum_of_Squares=NA}
    outputList=list(isThisaFit=isThisaFit,
                    randomParameter=randomParameter,
                    residual_Sum_of_Squares=residual_Sum_of_Squares)
    return(outputList)
  }