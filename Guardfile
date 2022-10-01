guard :shell do
  watch(/(.*)test.dart/) { |m|
    if run_all? m
      run_test
    else
      run_test m[0]
    end
  }

  watch(/lib\/(.*).dart/) { |m|
    run_test "test/#{m[1]}_test.dart"
  }
end

def run_test(file = nil)
  system "flutter test --no-pub -r expanded #{file}"
end

def run_all?(match)
  match == []
end
