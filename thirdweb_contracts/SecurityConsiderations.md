## Data Structures

- Staking721 have used many complex data structures, Are there some possible optimization for alternatives?

## Oveflow

- While calculating the rewards, if overflow, will return zero. perhaps will encounter one scenario, the acutal rewards will less than the user's expected amount.

## Gas limit

- If the array is very huge, Is it will trigger the max gas limit? limit the array length?

## Precision problem

- The math formaula like this `(endTime - startTime) * staker.amountStaked * condition.rewardsPerUnitTime / condition.timeUnit` when calculating the rewards on the stakingCondition. But there are potential precisous problem.
- such as if stake one NFT. endTime - startTime = 5, condition.rewardsPerUnitTime = 6, condition.timeUnit =7. there are precision lost.
  - 5*1*6/4 = 30/4 =7.5, only can keep 7

My suggestion is `condition.rewardsPerUnitTime / condition.timeUnit` can consider using fixed-point library, such as https://github.com/PaulRBerg/prb-math.
keep the consistant of the precision.

- new:condition.rewardsPerUnitTime is more bigger than condition.timeUnit, so it dosen't matter for the precisoion problem.
