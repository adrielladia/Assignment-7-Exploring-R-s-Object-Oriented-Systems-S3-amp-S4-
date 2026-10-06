# Assignment 7: Generic functions, S3 and S4
# ------------------------------------------------------------

## 1. Load and inspect data ---------------------------------
data("mtcars")
head(mtcars)
str(mtcars)

## 2. Generic functions -------------------------------------
# print(), summary(), and plot() are S3 generics: they look at class(x)
# and call print.<class>, summary.<class>, etc.

class(mtcars)               # "data.frame"
print(head(mtcars))         # print.data.frame
summary(mtcars[, c("mpg", "hp", "wt")])   # summary.data.frame

# Object derived from the data: a linear model
fit <- lm(mpg ~ wt + hp, data = mtcars)
class(fit)                  # "lm"
print(fit)                  # print.lm
summary(fit)                # summary.lm (a different method, same generic)
plot(fit, which = 1)        # plot.lm -> residuals vs fitted

# Another derived object: a factor
cyl_f <- factor(mtcars$cyl)
class(cyl_f)                # "factor"
summary(cyl_f)              # summary.factor -> counts per level
plot(cyl_f)                 # plot.factor -> bar plot

# Same generic, different class -> different behavior
plot(mtcars$wt, mtcars$mpg) # plot.default (numeric vectors)

# Methods available for a generic
methods(summary)

# A generic that does NOT dispatch on a custom class:
# no mean.student_s3 exists, so R falls back to mean.default,
# which expects numeric/logical input and returns NA with a warning.
tmp <- list(name = "test", age = 29, GPA = 3.5)
class(tmp) <- "student_s3"
mean(tmp)                   # NA + warning: argument is not numeric or logical

## 3. S3 vs S4 ----------------------------------------------

### S3 --------------------------------------------------------
s3_obj <- list(name = "Adriel", age = 22, GPA = 3.8)
class(s3_obj) <- "student_s3"

# Before defining a method, print() falls back to print.default
print(unclass(s3_obj))

# Method for an existing generic
print.student_s3 <- function(x, ...) {
  cat("S3 student\n")
  cat("  Name:", x$name, "\n")
  cat("  Age: ", x$age, "\n")
  cat("  GPA: ", x$GPA, "\n")
  invisible(x)
}
print(s3_obj)
s3_obj                      # auto-print also dispatches to print.student_s3

# Our own S3 generic
describe <- function(x, ...) UseMethod("describe")
describe.default <- function(x, ...) cat("No describe() method for this class\n")
describe.student_s3 <- function(x, ...) {
  cat(x$name, "is", x$age, "with a GPA of", x$GPA, "\n")
}
describe(s3_obj)
describe(42)                # falls to describe.default

### S4 --------------------------------------------------------
setClass("student_s4",
         slots = c(name = "character", age = "numeric", GPA = "numeric"))
s4_obj <- new("student_s4", name = "Adriel", age = 22, GPA = 3.8)

# Default display before we define a method
s4_obj

# show() is the S4 equivalent of print for auto-printing
setMethod("show", "student_s4", function(object) {
  cat("S4 student\n")
  cat("  Name:", object@name, "\n")
  cat("  Age: ", object@age, "\n")
  cat("  GPA: ", object@GPA, "\n")
})
s4_obj
print(s4_obj)               # print() on an S4 object calls show()

# Our own S4 generic + method
setGeneric("describe4", function(x, ...) standardGeneric("describe4"))
setMethod("describe4", "student_s4", function(x, ...) {
  cat(x@name, "is", x@age, "with a GPA of", x@GPA, "\n")
})
describe4(s4_obj)

# S4 enforces slot types; S3 does not
s3_bad <- list(name = 123, age = "old", GPA = "high")
class(s3_bad) <- "student_s3"   # accepted, no complaints
try(new("student_s4", name = 123, age = "old", GPA = "high"))  # error

## 4. Inspecting class system and type -----------------------
is.object(s3_obj); isS4(s3_obj)   # TRUE FALSE -> S3
is.object(s4_obj); isS4(s4_obj)   # TRUE TRUE  -> S4

class(s3_obj); class(s4_obj)
inherits(s3_obj, "student_s3")
is(s4_obj, "student_s4")
isVirtualClass("student_s4")

typeof(s3_obj)              # "list"
typeof(s4_obj)              # "S4"
typeof(1L)                  # "integer"
typeof(mtcars)              # "list" (a data.frame is a list underneath)
mode(mtcars); storage.mode(1L)

# Introspection helpers
attributes(s3_obj)          # $names, $class
slotNames("student_s4")
getSlots("student_s4")
isGeneric("describe4")
existsMethod("describe4", "student_s4")
showMethods("describe4")
# Optional: sloop::otype(s3_obj); sloop::otype(s4_obj)