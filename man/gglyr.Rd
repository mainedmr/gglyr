% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gglyr.R
\name{gglyr}
\alias{gglyr}
\title{Load gglyr}
\usage{
gglyr(name, verbose = F, ...)
}
\arguments{
\item{name}{Name of the layer to load.}

\item{verbose}{Defaults to false, if true the layer name and comment will be printed upon load.}

\item{...}{Additional arguments to be passed if the ggproto is a function}
}
\value{
ggproto object for use in ggplot2
}
\description{
Loads a ggproto object from the current library.
}
