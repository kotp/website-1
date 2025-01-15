import { createStoreWithMiddlewares } from './utils'

type TestStore = {
  inspectedTestResult: NewTestResult | null
  setInspectedTestResult: (inspectedTestResult: NewTestResult | null) => void
  inspectedPreviousTestResult: PreviousTestResult | null
  setInspectedPreviousTestResult: (
    inspectedTestResult: PreviousTestResult | null
  ) => void
  testSuiteResult: TestSuiteResult<NewTestResult> | null
  setTestSuiteResult: (
    testSuiteResult: TestSuiteResult<NewTestResult> | null
  ) => void
  previousTestSuiteResult: TestSuiteResult<PreviousTestResult> | null
  setPreviousTestSuiteResult: (
    testSuiteResult: TestSuiteResult<PreviousTestResult> | null
  ) => void
  flatPreviewTaskTests: TaskTest[]
  setFlatPreviewTaskTests: (flatPreviewTaskTests: TaskTest[]) => void
  setInspectedPreviewTaskTest: (inspectedPreviewTaskTest: TaskTest) => void
  inspectedPreviewTaskTest: TaskTest
  hasSyntaxError: boolean
  setHasSyntaxError: (hasSyntaxError: boolean) => void
}

const useTestStore = createStoreWithMiddlewares<TestStore>(
  (set) => ({
    inspectedTestResult: null,
    setInspectedTestResult: (inspectedTestResult) => {
      set({ inspectedTestResult }, false, 'exercise/setTestResults')
    },
    flatPreviewTaskTests: [],
    setFlatPreviewTaskTests: (flatPreviewTaskTests) => {
      set(
        {
          flatPreviewTaskTests,
          inspectedPreviewTaskTest: flatPreviewTaskTests[0],
        },
        false,
        'exercise/setFlatPreviewTaskTests'
      )
    },
    inspectedPreviewTaskTest: {} as TaskTest,
    setInspectedPreviewTaskTest: (inspectedPreviewTaskTest) => {
      set(
        { inspectedPreviewTaskTest },
        false,
        'exercise/setInspectedPreviewTaskTest'
      )
    },
    inspectedPreviousTestResult: null,
    setInspectedPreviousTestResult: (inspectedPreviousTestResult) => {
      set({ inspectedPreviousTestResult }, false, 'exercise/setTestResults')
    },
    previousTestSuiteResult: null,
    setPreviousTestSuiteResult: (previousTestSuiteResult) => {
      set(
        { previousTestSuiteResult },
        false,
        'exercise/setPreviousTestSuiteResult'
      )
    },
    testSuiteResult: null,
    setTestSuiteResult: (testSuiteResult) => {
      set(
        { testSuiteResult: testSuiteResult },
        false,
        'exercise/setTestSuiteResult'
      )
    },
    hasSyntaxError: false,
    setHasSyntaxError: (hasSyntaxError) => {
      set({ hasSyntaxError }, false, 'exercise/setHasSyntaxError')
    },
  }),
  'TestStore'
)

export default useTestStore
