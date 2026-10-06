# Assignment 7: R Generic Functions, S3 and S4

This repo contains `assignment7.R`, my work on R generic functions and object systems.

## What's in the script
- **Data loading and inspection:** loads `mtcars` and inspects it with `head()` and `str()`
- **Generic functions:** applies `print()`, `summary()`, and `plot()` to a data frame, a linear model, and a factor, and shows a case where dispatch falls back to the default method
- **S3:** a `student_s3` class with custom `print` and `describe` methods
- **S4:** a `student_s4` class with typed slots, a `show` method, and a custom generic
- **Class and type inspection:** `isS4()`, `is.object()`, `class()`, `typeof()`, `slotNames()`, and more

## How to run
Open `assignment7.R` in RStudio and run it from top to bottom. No extra packages are required.

## Blog post
(https://adrielusf.blogspot.com/2026/10/assignment-7-exploring-rs.html)
