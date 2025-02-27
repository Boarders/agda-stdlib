------------------------------------------------------------------------
-- The Agda standard library
--
-- An effectful view of Delay
------------------------------------------------------------------------

{-# OPTIONS --without-K --sized-types #-}

module Codata.Sized.Delay.Effectful where

open import Codata.Sized.Delay
open import Function
open import Effect.Functor
open import Effect.Applicative
open import Effect.Monad
open import Data.These using (leftMost)

functor : ∀ {i ℓ} → RawFunctor {ℓ} (λ A → Delay A i)
functor = record { _<$>_ = λ f → map f }

module Sequential where

  applicative : ∀ {i ℓ} → RawApplicative {ℓ} (λ A → Delay A i)
  applicative = record
    { pure = now
    ; _⊛_  = λ df da → bind df (λ f → map f da)
    }

  applicativeZero : ∀ {i ℓ} → RawApplicativeZero {ℓ} (λ A → Delay A i)
  applicativeZero = record
    { applicative = applicative
    ; ∅           = never
    }

  monad : ∀ {i ℓ} → RawMonad {ℓ} (λ A → Delay A i)
  monad = record
    { return = now
    ; _>>=_  = bind
    }

  monadZero : ∀ {i ℓ} → RawMonadZero {ℓ} (λ A → Delay A i)
  monadZero = record
    { monad           = monad
    ; applicativeZero = applicativeZero
    }

module Zippy where

  applicative : ∀ {i ℓ} → RawApplicative {ℓ} (λ A → Delay A i)
  applicative = record
    { pure = now
    ; _⊛_  = zipWith id
    }

  applicativeZero : ∀ {i ℓ} → RawApplicativeZero {ℓ} (λ A → Delay A i)
  applicativeZero = record
    { applicative = applicative
    ; ∅           = never
    }

  alternative : ∀ {i ℓ} → RawAlternative {ℓ} (λ A → Delay A i)
  alternative = record
    { applicativeZero = applicativeZero
    ; _∣_             = alignWith leftMost
    }
