% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/flatten_resource.R
\name{flatten_resource}
\alias{flatten_resource}
\title{Flatten resource}
\usage{
flatten_resource(datapackage, resource_name, join = NULL)
}
\arguments{
\item{datapackage}{path to a datapackage.json file}

\item{resource_name}{base resource to flatten}

\item{join}{if NULL all foreign key relations are joined. Otherwise a
character vector specifying which resources should be joined.}
}
\description{
Performs several left joins following the foreign keys relations
specified in the table schema of the flattened resource.
}
\details{
Starting from the resource \code{resource_name} several left joins are performed.

Duplicate columns names are renamed for disambiguation.
}
\examples{
\dontrun{
flatten_resource('datapackage.json', resource_name = 'fact-table'))

flatten_resource('datapackage.json',
                 resource_name = 'fact-table',
                 join = c('dim-a', 'dim-a')))
}
}
