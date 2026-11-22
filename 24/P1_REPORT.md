# P1 Report: Department Assignment Puzzle, Reloaded

## Solution Count for Clues 1–8
Running `count_solutions([1,2,3,4,5,6,7,8], N)` gives:

**`N = 3`**

## What This Tells Us About the Puzzle
A well-posed logic grid puzzle has a unique solution (`N = 1`). Finding `N = 3` shows that Clues 1 through 8 **underconstrain** the search space and leave three distinct valid assignments:

1. **Solution 1**
   - `Alex = [design, java, embedded]`
   - `Ben = [development, javascript, web]`
   - `Carla = [testing, python, AI]`
   - `Dana = [research, c++, data]`

2. **Solution 2**
   - `Alex = [testing, python, embedded]`
   - `Ben = [development, javascript, web]`
   - `Carla = [design, java, AI]`
   - `Dana = [research, c++, data]`

3. **Solution 3**
   - `Alex = [design, java, AI]`
   - `Ben = [development, javascript, web]`
   - `Carla = [research, c++, data]`
   - `Dana = [testing, python, embedded]`

### Why Only One Solution Can Be Isolated Without Names
Across all three solutions, Ben is fixed to `[development, javascript, web]`, and the `(research, c++, data)` triple is fixed. However, Solutions 2 and 3 use the **exact same set of four `(Department, Language, Project)` tuples**—they only permute those tuples among Alex, Carla, and Dana. Consequently, no name-free clue can distinguish Solution 2 from Solution 3.

Only **Solution 1** has a distinct attribute pairing (`testing` with `AI`, and `design` with `embedded`). Adding **Clue 9**:

> *The friend who prefers the AI project works in the testing department.*

is true in Solution 1 and false in Solutions 2 and 3, reducing `count_solutions([1,2,3,4,5,6,7,8,9], N)` to **`N = 1`**.