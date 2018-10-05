#!/bin/bash

echo "Applying migration IsEoriForContactPerson"

echo "Adding routes to conf/app.routes"

echo "" >> ../conf/app.routes
echo "GET        /isEoriForContactPerson                        controllers.IsEoriForContactPersonController.onPageLoad(mode: Mode = NormalMode)" >> ../conf/app.routes
echo "POST       /isEoriForContactPerson                        controllers.IsEoriForContactPersonController.onSubmit(mode: Mode = NormalMode)" >> ../conf/app.routes

echo "GET        /changeIsEoriForContactPerson                  controllers.IsEoriForContactPersonController.onPageLoad(mode: Mode = CheckMode)" >> ../conf/app.routes
echo "POST       /changeIsEoriForContactPerson                  controllers.IsEoriForContactPersonController.onSubmit(mode: Mode = CheckMode)" >> ../conf/app.routes

echo "Adding messages to conf.messages"
echo "" >> ../conf/messages.en
echo "isEoriForContactPerson.title = isEoriForContactPerson" >> ../conf/messages.en
echo "isEoriForContactPerson.heading = isEoriForContactPerson" >> ../conf/messages.en
echo "isEoriForContactPerson.checkYourAnswersLabel = isEoriForContactPerson" >> ../conf/messages.en
echo "isEoriForContactPerson.error.required = Select yes if isEoriForContactPerson" >> ../conf/messages.en

echo "Adding to UserAnswersEntryGenerators"
awk '/trait UserAnswersEntryGenerators/ {\
    print;\
    print "";\
    print "  implicit lazy val arbitraryIsEoriForContactPersonUserAnswersEntry: Arbitrary[(IsEoriForContactPersonPage.type, JsValue)] =";\
    print "    Arbitrary {";\
    print "      for {";\
    print "        page  <- arbitrary[IsEoriForContactPersonPage.type]";\
    print "        value <- arbitrary[Boolean].map(Json.toJson(_))";\
    print "      } yield (page, value)";\
    print "    }";\
    next }1' ../test/generators/UserAnswersEntryGenerators.scala > tmp && mv tmp ../test/generators/UserAnswersEntryGenerators.scala

echo "Adding to PageGenerators"
awk '/trait PageGenerators/ {\
    print;\
    print "";\
    print "  implicit lazy val arbitraryIsEoriForContactPersonPage: Arbitrary[IsEoriForContactPersonPage.type] =";\
    print "    Arbitrary(IsEoriForContactPersonPage)";\
    next }1' ../test/generators/PageGenerators.scala > tmp && mv tmp ../test/generators/PageGenerators.scala

echo "Adding to CacheMapGenerator"
awk '/val generators/ {\
    print;\
    print "    arbitrary[(IsEoriForContactPersonPage.type, JsValue)] ::";\
    next }1' ../test/generators/CacheMapGenerator.scala > tmp && mv tmp ../test/generators/CacheMapGenerator.scala

echo "Adding helper method to CheckYourAnswersHelper"
awk '/class/ {\
     print;\
     print "";\
     print "  def isEoriForContactPerson: Option[AnswerRow] = userAnswers.get(IsEoriForContactPersonPage) map {";\
     print "    x => AnswerRow(\"isEoriForContactPerson.checkYourAnswersLabel\", if(x) \"site.yes\" else \"site.no\", true, routes.IsEoriForContactPersonController.onPageLoad(CheckMode).url)"; print "  }";\
     next }1' ../app/utils/CheckYourAnswersHelper.scala > tmp && mv tmp ../app/utils/CheckYourAnswersHelper.scala

echo "Migration IsEoriForContactPerson completed"
