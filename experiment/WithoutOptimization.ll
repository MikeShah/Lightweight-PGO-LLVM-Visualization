; ModuleID = 'experiment.cpp'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.F = type { i32 }
%struct.G = type { i32, i32 }
%struct.H = type { %struct.F, i32 }

; Function Attrs: nounwind uwtable
define i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  %myF = alloca %struct.F, align 4
  %myG = alloca %struct.G, align 4
  %myH = alloca %struct.H, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %retval
  %a = getelementptr inbounds %struct.F, %struct.F* %myF, i32 0, i32 0
  store i32 2, i32* %a, align 4
  %b = getelementptr inbounds %struct.G, %struct.G* %myG, i32 0, i32 0
  store i32 3, i32* %b, align 4
  %c = getelementptr inbounds %struct.G, %struct.G* %myG, i32 0, i32 1
  store i32 4, i32* %c, align 4
  %d = getelementptr inbounds %struct.H, %struct.H* %myH, i32 0, i32 0
  %a1 = getelementptr inbounds %struct.F, %struct.F* %d, i32 0, i32 0
  store i32 5, i32* %a1, align 4
  %e = getelementptr inbounds %struct.H, %struct.H* %myH, i32 0, i32 1
  store i32 6, i32* %e, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %0, 100
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %1 = load i32, i32* %i, align 4
  %d2 = getelementptr inbounds %struct.H, %struct.H* %myH, i32 0, i32 0
  %a3 = getelementptr inbounds %struct.F, %struct.F* %d2, i32 0, i32 0
  store i32 %1, i32* %a3, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %2 = load i32, i32* %i, align 4
  %inc = add nsw i32 %2, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 0
}

attributes #0 = { nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 "}
