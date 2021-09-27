#include "suorb/tmp.hpp"

#include <gtest/gtest-message.h>    // for Message
#include <gtest/gtest-test-part.h>  // for TestPartResult
#include <memory>                   // for allocator
#include "gtest/gtest_pred_impl.h"  // for Test, AssertionResult, InitGoogle...

TEST(TmpAddTest, CheckValues)
{
  ASSERT_EQ(tmp::add(1, 2), 3);
  EXPECT_TRUE(true);
}

int main(int argc, char **argv)
{
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
