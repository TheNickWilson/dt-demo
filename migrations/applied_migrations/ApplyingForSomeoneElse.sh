#!/bin/bash

echo "Applying migration ApplyingForSomeoneElse"

echo "Adding routes to conf/app.routes"

echo "" >> ../conf/app.routes
echo "GET        /applyingForSomeoneElse                        controllers.ApplyingForSomeoneElseController.onPageLoad(mode: Mode = NormalMode)" >> ../conf/app.routes
echo "POST       /applyingForSomeoneElse                        controllers.ApplyingForSomeoneElseController.onSubmit(mode: Mode = NormalMode)" >> ../conf/app.routes

echo "GET        /changeApplyingForSomeoneElse                  controllers.ApplyingForSomeoneElseController.onPageLoad(mode: Mode = CheckMode)" >> ../conf/app.routes
echo "POST       /changeApplyingForSomeoneElse                  controllers.ApplyingForSomeoneElseController.onSubmit(mode: Mode = CheckMode)" >> ../conf/app.routes

echo "Adding messages to conf.messages"
echo "" >> ../conf/messages.en
echo "applyingForSomeoneElse.title = applyingForSomeoneElse" >> ../conf/messages.en
echo "applyingForSomeoneElse.heading = applyingForSomeoneElse" >> ../conf/messages.en
echo "applyingForSomeoneElse.checkYourAnswersLabel = applyingForSomeoneElse" >> ../conf/messages.en
echo "applyingForSomeoneElse.error.required = Select yes if applyingForSomeoneElse" >> ../conf/messages.en

echo "Adding to UserAnswersEntryGenerators"
awk '/trait UserAnswersEntryGenerators/ {\
    print;\
    print "";\
    print "  implicit lazy val arbitraryApplyingForSomeoneElseUserAnswersEntry: Arbitrary[(ApplyingForSomeoneElsePage.type, JsValue)] =";\
    print "    Arbitrary {";\
    print "      for {";\
    print "        page  <- arbitrary[ApplyingForSomeoneElsePage.type]";\
    print "        value <- arbitrary[Boolean].map(Json.toJson(_))";\
    print "      } yield (page, value)";\
    print "    }";\
    next }1' ../test/generators/UserAnswersEntryGenerators.scala > tmp && mv tmp ../test/generators/UserAnswersEntryGenerators.scala

echo "Adding to PageGenerators"
awk '/trait PageGenerators/ {\
    print;\
    print "";\
    print "  implicit lazy val arbitraryApplyingForSomeoneElsePage: Arbitrary[ApplyingForSomeoneElsePage.type] =";\
    print "    Arbitrary(ApplyingForSomeoneElsePage)";\
    next }1' ../test/generators/PageGenerators.scala > tmp && mv tmp ../test/generators/PageGenerators.scala

echo "Adding to CacheMapGenerator"
awk '/val generators/ {\
    print;\
    print "    arbitrary[(ApplyingForSomeoneElsePage.type, JsValue)] ::";\
    next }1' ../test/generators/CacheMapGenerator.scala > tmp && mv tmp ../test/generators/CacheMapGenerator.scala

echo "Adding helper method to CheckYourAnswersHelper"
awk '/class/ {\
     print;\
     print "";\
     print "  def applyingForSomeoneElse: Option[AnswerRow] = userAnswers.get(ApplyingForSomeoneElsePage) map {";\
     print "    x => AnswerRow(\"applyingForSomeoneElse.checkYourAnswersLabel\", if(x) \"site.yes\" else \"site.no\", true, routes.ApplyingForSomeoneElseController.onPageLoad(CheckMode).url)"; print "  }";\
     next }1' ../app/utils/CheckYourAnswersHelper.scala > tmp && mv tmp ../app/utils/CheckYourAnswersHelper.scala

echo "Migration ApplyingForSomeoneElse completed"
