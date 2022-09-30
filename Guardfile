guard :shell do
  watch(/(.*)test.dart/) { |m|
    if run_all? m
      system 'flutter test'
    else
      system "flutter test #{m[0]}"
    end
  }
end

def run_all?(match)
  match == []
end
